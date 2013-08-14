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
)

func main() {
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

      pop := keyboard.Population(8)
      gen := keyboard.Evolve(pop, 1000)

      gen[0].Display()
      fmt.Printf("%d \n", keyboard.Score(gen[0]))
    }
}

