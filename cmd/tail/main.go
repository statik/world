package main

import "time"

func main() {
	// Block forever.
	go func() {
		interval := 10
		for {
			time.Sleep(time.Duration(interval) * time.Second)
		}
	}()
	select {}

	// https://www.youtube.com/watch?v=67ragXpWsAI
}
