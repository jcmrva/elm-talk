module RES exposing (Part)


type alias Part =
    { before : Maybe String
    , emoji : Char
    , after : Maybe String
    }
