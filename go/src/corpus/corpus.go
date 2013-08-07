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
      fmt.Println("Scoring...")
      for n, k := range keyboard.PredefinedKeyboards() {
        fmt.Printf("%-25s\n", n)
        k.Display()
        fmt.Println("")
      }
    default:  // evolve
      fmt.Println("Evolving...")

      pop := keyboard.Population()
      gen := keyboard.Evolve(pop, 1000)

      gen[0].Display()
      fmt.Printf("%d \n", keyboard.Score(gen[0]))
    }
}

