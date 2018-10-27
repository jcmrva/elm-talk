module Main exposing (main)


import Browser
import Html exposing (Html, button, div, text)


type alias Model =
    { title : String
    , name : String 
    }


initialModel : String -> ( Model, Cmd Msg )
initialModel flag =
    ( { name = flag, title = "Elm Demo" }, Cmd.none )


type Msg
    = NoOp





update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )



type alias Document msg =
    { title : String
    , body : List (Html msg)
    }



view : Model -> Document Msg
view model =
    { title = model.title
    , body =
        [ div []
            []
        ]
    } 


main =
    Browser.document
        { init = initialModel
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none