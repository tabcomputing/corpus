# NOTES

## Haskell

I really wanted to write a version of the corpus keyboard evolution code in Haskell. And I started to do so based on the Elixir code. I did not think it would be too difficult. After all they are both functional programming languages. Sadly I quickly ran into a couple of stumpers. First was the problem of randomly shuffling a list. I could not find any built-in way to do it, so I decided I would have to implement it myself. Of course to do it well I wisely thought it best to see how others did it and copy them. This is the wonderful code one ultimately arrives at:

```haskell
    import Control.Monad
    import Control.Monad.ST
    import Control.Monad.Random
    import System.Random
    import Data.Array.ST
    import GHC.Arr

    shuffle :: RandomGen g => [a] -> Rand g [a]
    shuffle xs = do
        let l = length xs
        rands <- take l `fmap` getRandomRs (0, l-1)
        let ar = runSTArray $ do
            ar <- thawSTArray $ listArray (0, l-1) xs
            forM_ (zip [0..(l-1)] rands) $ \(i, j) -> do
                vi <- readSTArray ar i
                vj <- readSTArray ar j
                writeSTArray ar j vi
                writeSTArray ar i vj
            return ar
        return (elems ar)
```

When you see something like that, my advice is to back away slowly, then make a mad dash the door. If you stay, you're going to end up wasting half your life threading academic needles and gazing at digital belly buttons.

Of course, I was never one to take my own advice, so I puffed my chest and carried on... right up to the point that I needed a function to swap list elements. And in similar fashion I ended up with this lovely bit of code:

```haskell
--
-- If you have to use this function, arrays may be a better choice.
--
swap ls i j = [get k x | (k, x) <- zip [0..length ls - 1] ls]
where get k x | k == i = ls !! j
| k == j = ls !! i
| otherwise = x
```

That readability of this code is bad enough. But I was also being told that I needed to rewrite my whole program to use arrays instead of lists? That might not be a big deal if list and array were largely polymorphic, but from what I could glean from a quick review of the [documentation](http://www.haskell.org/haskellwiki/Arrays), the interfaces are quite different. And not just between list and array, apparently there are two different interfaces between the *nine* different arrays Haskell has to choose from too!

There are a lot of interesting things about Haskell, but truth be told, for the programmer that actually wants to *get things done* and not have to spend a better part of a decade learning the academic minutiae of functional programming esoterica, there are much much better languages out there. If you want to stay functional check out Elixir, for instance.

*And don't even get me started on Monads!*

