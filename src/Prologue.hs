
{-# OPTIONS_GHC -fno-warn-orphans #-}
{-# LANGUAGE FlexibleContexts          #-}
{-# LANGUAGE LambdaCase                #-}
{-# LANGUAGE MultiParamTypeClasses     #-}
{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE RankNTypes #-}

module Prologue (
    module Prologue,
    module X
) where

import qualified Data.Traversable                   as Traversable

import           Data.Binary.Instances.Missing      ()
import           Data.Default.Instances.Missing     ()
import           Data.Foldable                      (forM_)
import qualified Prelude
import           Text.Show.Pretty                   as X (ppShow)

import           Prelude                            as X hiding (mapM, mapM_, print, putStr, putStrLn, (++), (.), curry, uncurry)
import           Data.Function                      as X (on)
import           Data.Maybe                         as X (mapMaybe)
import           Data.Default                       as X
import           Control.Lens                       as X 
import           Control.Lens.Utils                 as X
import           Data.String.Class                  as X (IsString (fromString), ToString (toString))
import           Control.Applicative                as X
import           Control.Conditional                as X (if', ifM, unless, unlessM, when, whenM, notM, xorM)
import           Control.Monad                      as X (MonadPlus, mplus, mzero, void, join)
import           Control.Monad.IO.Class             as X (MonadIO, liftIO)
import           Control.Monad.Trans                as X (MonadTrans, lift)
import           Data.Foldable                      as X (Foldable, traverse_)
import           Data.Monoid                        as X (Monoid, mappend, mconcat, mempty, (<>))
import           Control.Lens.Wrapped               as X (Wrapped, _Wrapped, _Unwrapped, _Wrapping, _Unwrapping, _Wrapped', _Unwrapped', _Wrapping', _Unwrapping', op, ala, alaf)
import           Data.Text.Class                    as X (FromText (fromText), IsText, ToText (toText))
import           Data.Text.Lazy                     as X (Text)
import           Data.Typeable                      as X (Typeable)
import           GHC.Generics                       as X (Generic)
import           GHC.Exts                           as X (Constraint)
import           Control.Monad.Fix                  as X (MonadFix)
import           Control.Monad                      as X ((<=<), (>=>))
import           Control.Monad.Base                 as X
import           Data.Traversable                   as X (mapM)
import           Data.Foldable                      as X (mapM_)
import           Control.Error.Util                 as X (isLeft, isRight)
import           Data.String.QQ                     as X (s)
import           GHC.TypeLits                       as X (Nat, Symbol, SomeNat, SomeSymbol, KnownNat, natVal)
import           Data.Typeable                      as X (Proxy(Proxy), typeOf, typeRep)
import           Data.Convert                       as X
import           Data.Layer                         as X
import           Data.Tuple.Curry                   as X (Curry)
import           Data.Container.Class               as X (Container, Index, Item, intercalate)
import           Data.Container.List                as X (FromList, fromList, ToList, toList)
import           Data.Functor.Utils                 as X
import qualified Data.Tuple.Curry                   as Tuple


(++) :: Monoid a => a -> a -> a
(++) = mappend

-- IO

print :: (MonadIO m, Show s) => s -> m ()
print    = liftIO . Prelude.print

printLn :: MonadIO m => m ()
printLn = putStrLn ""

putStr :: MonadIO m => String -> m ()
putStr   = liftIO . Prelude.putStr

putStrLn :: MonadIO m => String -> m ()
putStrLn = liftIO . Prelude.putStrLn

pprint :: (MonadIO m, Show s) => s -> m ()
pprint = putStrLn . ppShow

--


fromJustM :: Monad m => Maybe a -> m a
fromJustM Nothing  = fail "Prelude.fromJustM: Nothing"
fromJustM (Just x) = return x


whenLeft :: (Monad m) => Either a b -> (a -> m ()) -> m ()
whenLeft e f = case e of
    Left  v -> f v
    Right _ -> return ()


whenLeft' :: (Monad m) => Either a b -> m () -> m ()
whenLeft' e f = whenLeft e (const f)


whenRight :: (Monad m) => Either a b -> (b -> m ()) -> m ()
whenRight e f = case e of
    Left  _ -> return ()
    Right v -> f v


whenRight' :: (Monad m) => Either a b -> m () -> m ()
whenRight' e f = whenRight e $ const f


($>) :: (Functor f) => a -> f b -> f b
($>) =  fmap . flip const


withJust :: Monad m => Maybe a -> (a -> m ()) -> m ()
withJust = forM_


lift2 :: (Monad (t1 m), Monad m, MonadTrans t, MonadTrans t1)
      => m a -> t (t1 m) a
lift2 = lift . lift


lift3 :: (Monad (t1 (t2 m)), Monad (t2 m), Monad m, MonadTrans t, MonadTrans t1, MonadTrans t2)
      => m a -> t (t1 (t2 m)) a
lift3 = lift . lift2


switch :: Monad m => m Bool -> a -> a -> m a
switch cond fail ok = do
  c <- cond
  return $ if c then ok else fail




show' :: (Show a, IsString s) => a -> s
show' = fromString . Prelude.show

foldlDef :: (a -> a -> a) -> a -> [a] -> a
foldlDef f d = \case
    []     -> d
    (x:xs) -> foldl f x xs


mapOver :: (Lens' a b) -> (b -> (b, out)) -> (a -> (a, out))
mapOver lens f s = (s & lens .~ a, out) where
    (a, out) = f $ s ^. lens

mapOverM :: Monad m => (Lens' a b) -> (b -> m (b, out)) -> (a -> m (a, out))
mapOverM lens f a = do
    (b, out) <- f $ a ^. lens
    return $ (a & lens .~ b, out)


ifElseId :: Bool -> (a -> a) -> (a -> a)
ifElseId cond a = if cond then a else id

curry   :: Curry a b => a -> b
uncurry :: Curry a b => b -> a
curry   = Tuple.curryN
uncurry = Tuple.uncurryN



