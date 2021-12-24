{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, OverloadedStrings #-}

module Database.Esqueleto.Postgis.Geography (intersects, intersectsMaybe) where

import Database.Esqueleto (SqlExpr, Value)
import Database.Esqueleto.Internal.Sql (unsafeSqlFunction)
import Data.Geometry.Geos.Geometry (Some)
import Database.Persist.Postgis.Geography (Geography)

class IsGeography g
instance IsGeography (Geography a)
instance IsGeography (Some Geography)
instance IsGeography a => IsGeography (Maybe a)

intersects :: (IsGeography a, IsGeography b)
           => SqlExpr (Value a) -> SqlExpr (Value b) -> SqlExpr (Value Bool)
intersects a b = unsafeSqlFunction "ST_Intersects" (a, b)
infixl 7 `intersects`

intersectsMaybe :: (IsGeography a, IsGeography b)
                => SqlExpr (Maybe (Value a)) -> SqlExpr (Maybe (Value b))
                -> SqlExpr (Maybe (Value Bool))
intersectsMaybe a b = unsafeSqlFunction "ST_Intersects" (a, b)
infixl 7 `intersects`
