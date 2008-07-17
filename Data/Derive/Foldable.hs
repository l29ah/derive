{-# LANGUAGE TemplateHaskell #-}


{-
    This module is not written/maintained by the usual Data.Derive author.

    MAINTAINER: Twan van Laarhoven 
    EMAIL: "twanvl" ++ "@" ++ "gmail" ++ "." ++ "com"

    Please send all patches to this module to Neil (ndmitchell -at- gmail),
    and CC Twan.
-}

-- NOTE: Cannot be guessed as it relies on type information

module Data.Derive.Foldable(makeFoldable, makeFoldableN) where

import qualified Data.Foldable ( foldr )

import Language.Haskell.TH.All
import Data.DeriveTraversal


makeFoldable :: Derivation
makeFoldable = makeFoldableN 1

makeFoldableN :: Int -> Derivation
makeFoldableN n = traversalDerivation1 foldrTraversal{traversalArg = n} "Foldable"

foldrTraversal = defaultTraversalType
        { traversalName   = 'Data.Foldable.foldr
        , traversalFunc   = \n a -> l1 "flip" (l1 n a)
        , traversalPlus   = fail "variable used in multiple positions in a data type"
        , traversalId     = l1 "flip" (l0 "const")
        , traverseTuple   =         foldr (.:) id'
        , traverseCtor    = const $ foldr (.:) id'
        , traverseFunc    = \pat rhs -> sclause [vr "_f", vr "b", pat] (AppE rhs (vr "b"))
        }
