#!/usr/bin/env python3

from __future__ import annotations

import argparse
import csv
import datetime
import json
import os
import string
import sys
import typing as t
import zipfile


def argparser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser()
    parser.add_argument("input")
    parser.add_argument("messages")
    parser.add_argument("channels")
    parser.add_argument("users")
    return parser


def main(argv: t.List[str], env: t.Dict[str, str]) -> None:
    args = argparser().parse_args(argv[1:])
    input: str = args.input

    def predicate(message: Message) -> bool:
        bots = {
            "B1X4URHSB": "deployer",
            "U9FD0GLG1": "github",
            "USLACKBOT": "slackbot",
            "BG0F2RSKT": "google",
        }
        if message.type != "message" or message.user_id in bots:
            return False
        subject = "UTC4VGGET"
        return (
            message.user_id == subject
            or f"<@{subject}>" in message.raw_text
            or "Daily Pay" in message.raw_text
            or "DP" in message.raw_text
            or "DailyPay" in message.raw_text
        )

    outs: t.List[t.Tuple[str, t.Dict[str, t.Any]]] = []

    with zipfile.ZipFile(input) as f:
        archive = Archive(f)
        outs.append((args.channels, to_rows(dict(archive.channels), "id", "channel")))
        outs.append((args.users, to_rows(dict(archive.users), "id", "username")))
        outs.append(
            (
                args.messages,
                [m.asdict() for m in sorted(archive.some_messages(predicate), key=lambda x: x.raw_timestamp)],
            )
        )

    for name, rows in outs:
        if not rows:
            continue
        with open(name, "w") as f:
            writer = csv.DictWriter(f, rows[0].keys())
            writer.writeheader()
            writer.writerows(rows)


Row = t.Dict[str, t.Any]
Mapping = t.Dict[t.Any, t.Any]
Element = t.Dict[t.Any, t.Any]


class Mapper:
    def __init__(self, mapping: Mapping):
        self.mapping = mapping

    def update(self, mapping: Mapping):
        self.mapping.update(mapping)

    def text(self, message: Message) -> str:
        # elements = [self.element_text(e) for e in message.elements]
        # if elements:
        #     return "".join(elements)
        return message.raw_text

    def row(self, message: Message) -> Row:
        row = dict([(k, getattr(message, k, None)) for k in message.fields])
        try:
            row["text"] = self.text(message)
        except:
            debug(message.raw)
            raise
        return row

    def element_text(self, raw: Element) -> str:
        element_type = raw["type"]
        by_type = getattr(self, f"{element_type}_text")
        return by_type(raw)

    def text_text(self, raw: Element) -> str:
        return raw["text"]

    def link_text(self, raw: Element) -> str:
        url = raw["url"]
        return f"<{url}>"

    def emoji_text(self, raw: Element) -> str:
        name = raw["name"]
        return f":{name}:"

    def user_text(self, raw: Element) -> str:
        user_id = raw["user_id"]
        return f"@{self.mapping[user_id]}"


def to_rows(data: t.Dict[t.Any, t.Any], keys: str, values: str) -> t.List[t.Dict[t.Any, t.Any]]:
    rows = []
    for k, v in data.items():
        row = {}
        row[keys] = k
        row[values] = v
        rows.append(row)
    return rows


class Archive:
    def __init__(self, raw: zipfile.ZipFile):
        self.raw = raw
        self.open = self.raw.open

    @property
    def mapper(self) -> Mapper:
        mapper = Mapper({})
        mapper.update(self.users)
        return mapper

    @property
    def users(self) -> Mapping:
        return self.mapping("users.json")

    @property
    def channels(self) -> Mapping:
        return self.mapping("channels.json")

    def mapping(self, name: str) -> Mapping:
        return dict([(i["id"], i["name"]) for i in json.load(self.open(name))])

    @property
    def files(self) -> t.Iterator[zipfile.ZipInfo]:
        for info in self.raw.infolist():
            if not info.is_dir():
                yield info

    @property
    def message_files(self) -> t.Iterator[zipfile.ZipInfo]:
        mappings = [
            "users.json",
            "channels.json",
            "dms.json",
            "groups.json",
            "integration_logs.json",
        ]

        for info in self.files:
            if info.filename in mappings:
                continue
            yield info

    @property
    def messages(self) -> t.Iterator[Message]:
        ok = ["message"]
        return self.some_messages(lambda m: m.type in ok)

    def some_messages(self, predicate: t.Callable[[Message], bool]) -> t.Iterator[Message]:
        for message in self.all_messages:
            if predicate(message):
                yield message

    @property
    def all_messages(self) -> t.Iterator[Message]:
        for info in self.message_files:
            for item in json.load(self.open(info)):
                yield Message(item, filename=info.filename)


class Text(string.Template):
    delimiter = "<"
    pattern = r"""
        <(?:
        (?P<escaped>\<\<)|
        [@#](?P<named>[A-Z0-9]*)\>|
        [@#](?P<braced>[A-Z0-9]*)\>|
        (?P<invalid>)
        )
    """


class Message:
    fields = [
        "id",
        "source",
        "timestamp",
        "user_id",
        "real_name",
        "raw_text",
    ]

    def __init__(self, raw: t.Dict[str, t.Any], filename: t.Optional[str] = None):
        self.raw = raw
        self.filename = filename

    def asdict(self) -> t.Mapping[str, t.Any]:
        try:
            return dict([(k, getattr(self, k)) for k in self.fields])
        except:
            print(self.raw)
            raise

    @property
    def source(self) -> str:
        filename = self.filename or ""
        return filename.split("/")[0]

    @property
    def id(self) -> str:
        return self.raw.get("client_msg_id", "")

    @property
    def type(self) -> str:
        return self.raw.get("type", "unknown")

    @property
    def elements(self) -> t.Iterator[t.Dict[t.Any, t.Any]]:
        blocks = self.raw.get("blocks", [])
        if not blocks:
            return iter([{"type": "text", "text": self.raw["text"]}])

        for block in blocks:
            for outer_element in block["elements"]:
                for element in outer_element["elements"]:
                    yield element

    @property
    def user_id(self) -> str:
        return self.raw.get("user", self.raw.get("bot_id"))

    @property
    def real_name(self) -> str:
        user_profile = self.raw.get("user_profile")
        if user_profile:
            return user_profile["real_name"]
        return self.user_id

    @property
    def timestamp(self) -> str:
        return format_timestamp(self.raw_timestamp)

    @property
    def raw_timestamp(self) -> datetime.datetime:
        return from_timestamp(self.raw["ts"])

    @property
    def raw_text(self) -> str:
        return self.raw["text"]


class OldMessage(t.NamedTuple):
    channel: str
    user: str
    text: str
    timestamp: str
    fields = ["timestamp", "context", "user", "text"]

    @classmethod
    def init(cls, channel: str, mapping: Mapping, message: t.Dict[str, t.Any]) -> OldMessage:
        user = message.get("user", "")
        text = Text(message.get("text", "")).safe_substitute(mapping)

        return cls(
            channel=channel,
            text=text,
            timestamp=to_timestamp(message.get("ts", "")),
            user=mapping.get(user, user),
        )

    def asdict(self) -> t.Dict[str, t.Any]:
        return dict(self._asdict())


def writerow(message: Message, writer: csv.DictWriter):
    row = dict([(k, v) for k, v in message.asdict().items() if k in message.fields])
    writer.writerow(row)


def from_timestamp(ts: str) -> datetime.datetime:
    return datetime.datetime.utcfromtimestamp(float(ts))


def format_timestamp(ts: datetime.datetime) -> str:
    return ts.strftime("%Y-%m-%d %H:%M:%S")


def process_mapping(path: str) -> t.Dict[str, str]:
    return dict([(i["id"], i["name"]) for i in process_file(path)])


def process_file(name: str) -> t.Generator[t.Dict[t.Any, t.Any], None, None]:
    with open(name) as f:
        items = json.load(f)
        for item in items:
            yield item


def debug(data: t.Dict[t.Any, t.Any]):
    print(json.dumps(data, indent=1, sort_keys=True))


if __name__ == "__main__":
    sys.exit(main(list(sys.argv), dict(os.environ)))
