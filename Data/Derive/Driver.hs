
module Data.Derive.Driver(derive, derives, derivable) where

import Data.Generics
import Data.Derive
import Data.List
import Data.Maybe

import qualified Data.Derive.Eq
import qualified Data.Derive.BinaryDefer
import qualified Data.Derive.Binary


derivable :: [String]
derivable = map fst derivers

derivers = [("Eq",Data.Derive.Eq.derive)
           ,("BinaryDefer",Data.Derive.BinaryDefer.derive)
           ,("Binary",Data.Derive.Binary.derive)
           ]

getDeriver :: String -> (DataDef -> [String])
getDeriver x = fromMaybe (error $ "Do not know how to derive " ++ x) (lookup x derivers)



derive :: (Data a, Typeable a) => String -> a -> IO ()
derive s x = putStr $ unlines $ getDeriver s $ fromMaybe (error "Cannot derive for this type") (deriveOne x)


derives :: (Data a, Typeable a) => String -> a -> IO ()
derives s x = putStr $ unlines $ concat $ intersperse [""] $ map (getDeriver s) $ deriveMany x
