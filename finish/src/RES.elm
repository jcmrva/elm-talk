module RES exposing (..)

import Dict exposing (..)

type alias Part =
    { before : Maybe String
    , emoji : Char
    , after : Maybe String
    }

type alias Story =
    { title : Maybe String
    , parts : Dict Int Part
    }