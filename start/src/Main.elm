module Main exposing (main)


import Browser
import Html exposing (Html, button, div, text)


type alias Model =
    { title : String
    }


initialModel : flags -> ( Model, Cmd Msg )
initialModel _ =
    ( { title = "Elm Demo" }, Cmd.none )


type Msg
    = NoOp



update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        _ ->
            ( model, Cmd.none )



type alias Document msg =
    { title : String
    , body : List (Html msg)
    }



view : Model -> Document Msg
view model =
    { title = model.title
    , body =
        [ div [] []
        ]
    } 

main : Program () Model Msg
main =
    Browser.document
        { init = initialModel
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
