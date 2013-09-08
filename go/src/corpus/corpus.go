/******************************************************************************\
 * Corpus - Kayboard Assesment API
 * (c) 2013 Tab Computing
 *     All Rights Reserved
\******************************************************************************/

package main

import (
	  "fmt"
    "os"
	  "corpus/keyboard"
    "github.com/davecheney/profile"
)

func main() {
    defer profile.Start(profile.CPUProfile).Stop()

    cmd := "evolve"

    if len(os.Args) > 1 { 
      cmd = os.Args[1]  //strings.Join(os.Args[1:], " ")
    }

    switch cmd {
    case "score":
      fmt.Println("Scoring...\n")
      for i, k := range keyboard.SavedKeyboards() {
        fmt.Printf("%d)\n", i)
        k.Display()
      }
    default:  // evolve
      fmt.Println("Evolving...\n")

      // TODO: get 

      pop := keyboard.Population(8)
      gen := keyboard.Evolve(pop, 10)

      gen[0].Display()
      fmt.Printf("%d \n", keyboard.Score(gen[0]))
    }
}

