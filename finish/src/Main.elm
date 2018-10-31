module Main exposing (main)


import Browser
import Html exposing (Html, button, div, text, input)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, onBlur)


type alias Model =
    { title : String
    , name : String 
    }


initialModel : String -> ( Model, Cmd Msg )
initialModel flag =
    ( { name = "\u{1F987}", title = flag }, Cmd.none )


type Msg
    = NoOp
    | ChangeTitle String




update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )
        ChangeTitle t ->
            ( { model | title = t }, Cmd.none )



type alias Document msg =
    { title : String
    , body : List (Html msg)
    }




view : Model -> Document Msg
view model =
    { title = model.title
    , body =
        [ div []
            [
                text "Title: "
                ,input [ value model.title, onInput ChangeTitle ] []
            ]
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