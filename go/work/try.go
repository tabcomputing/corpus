package main

import (
  "fmt"
  "time"
  "math/rand"
)

func main() {
  n := 10000000  // ten million
  a := rand.Perm(100)

  t0 := time.Now()

  for i := 0; i < n; i++ {
    index(a, i % 100)
  }

  fmt.Printf("%.5f\n", time.Now().Sub(t0).Seconds())
}

func index(slice []int, value int) int {
  for i, v := range slice {
    if (v == value) {
      return i
    }
  }
  return -1
}

