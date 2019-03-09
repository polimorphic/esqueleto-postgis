{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, OverloadedStrings #-}

module Database.Esqueleto.Postgis.Geography (contains, intersects) where

import Database.Esqueleto (Esqueleto, SqlBackend, SqlExpr, SqlQuery, Value)
import Database.Esqueleto.Internal.Sql (unsafeSqlFunction)
import Data.Geometry.Geos.Types (Some)
import Database.Persist.Postgis.Geography (Geography)


class IsGeography g
instance IsGeography (Geography a)
instance IsGeography (Some Geography)
instance IsGeography a => IsGeography (Maybe a)

class Esqueleto query expr backend => EsqueletoGeography query expr backend where
    contains :: (IsGeography a, IsGeography b)
             => expr (Value a) -> expr (Value b) -> expr (Value Bool)
    intersects :: (IsGeography a, IsGeography b)
               => expr (Value a) -> expr (Value b) -> expr (Value Bool)
infixl 7 `contains`
infixl 7 `intersects`

instance EsqueletoGeography SqlQuery SqlExpr SqlBackend where
    contains a b = unsafeSqlFunction "ST_Contains" (a, b)
    intersects a b = unsafeSqlFunction "ST_Intersects" (a, b)
