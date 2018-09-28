{-# LANGUAGE MultiParamTypeClasses, OverloadedStrings #-}

module Database.Esqueleto.Postgis.Geography (intersects) where

import Database.Esqueleto (Esqueleto, SqlBackend, SqlExpr, SqlQuery, Value)
import Database.Esqueleto.Internal.Sql (unsafeSqlFunction)
import Database.Persist.Postgis.Geography
    ( GeographyDB, GeometryCollectionDB, LineStringDB, MultiLineStringDB
    , MultiPointDB, MultiPolygonDB, PointDB, PolygonDB
    )

class IsGeography g
instance IsGeography GeographyDB
instance IsGeography GeometryCollectionDB
instance IsGeography LineStringDB
instance IsGeography MultiLineStringDB
instance IsGeography MultiPointDB
instance IsGeography MultiPolygonDB
instance IsGeography PointDB
instance IsGeography PolygonDB
instance IsGeography a => IsGeography (Maybe a)

class Esqueleto query expr backend => EsqueletoGeography query expr backend where
    intersects :: (IsGeography a, IsGeography b)
               => expr (Value a) -> expr (Value b) -> expr (Value Bool)
infixl 7 `intersects`

instance EsqueletoGeography SqlQuery SqlExpr SqlBackend where
    intersects a b = unsafeSqlFunction "ST_Intersects" (a, b)
