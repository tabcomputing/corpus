package main

import (
	  "fmt"
    "os"
	  "corpus/layout"
)

func main() {
    cmd := "evolve"

    if len(os.Args) > 1 { 
      cmd = os.Args[1]  //strings.Join(os.Args[1:], " ")
    }

    switch cmd {
    case "score":
      fmt.Println("Scoring...")
      for n, k := range layout.PredefinedKeysets() {
        fmt.Printf("%-25s\n", n)
        k.Display()
        fmt.Println("")
      }
    default:  // evolve
        fmt.Println("Evolving...")

        pop := layout.Population(true)
        gen := layout.Evolve(pop, 1000)

        gen[0].Display()
        fmt.Printf("%d \n", layout.Score(gen[0]))
    }
}

