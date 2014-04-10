{-# LANGUAGE BangPatterns, ForeignFunctionInterface #-}
-- | This module defines a type for mutable, integer-valued counters.
-- Counters are non-negative, monotonically increasing values and can
-- be used to track e.g. the number of requests served since program
-- start.  All operations on counters are thread-safe.
module System.Remote.Counter
    (
      Counter
    , inc
    , add
    ) where

import Foreign.ForeignPtr (withForeignPtr)
import Foreign.Ptr (Ptr)

import System.Remote.Counter.Internal

-- | Increase the counter by one.
inc :: Counter -> IO ()
inc counter = add counter 1

add :: Counter -> Int -> IO ()
add (C fp) n = withForeignPtr fp $ \ p -> cAdd p n

-- | Increase the counter by the given amount.
foreign import ccall unsafe "hs_counter_add" cAdd :: Ptr Int -> Int -> IO ()
