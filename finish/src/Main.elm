module Main exposing (main)


import Browser
import Html exposing (Html, button, div, text, input)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Random.Char exposing (..)
import Random exposing (..)
import Set exposing (..)
import RES exposing (..)

type alias Model =
    { count : Int
    , emoji : Char
    , used : Set Char
    , repeats : Int
    , message : String
    , story : Maybe Story
    }

initialModel : flags -> ( Model, Cmd Msg )
initialModel _ =
    let 
        m = { count = 0, emoji = ' ', used = Set.empty, repeats = 0, message = "", story = Nothing }
    in 
        (m, Cmd.none)

max = 30

type Msg
    = GetEmoji
    | NewEmoji Char


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        newEmoji = Random.generate NewEmoji Random.Char.emoticon
    in
    case msg of
        GetEmoji ->
            if Set.size model.used < max then 
                (model, newEmoji)
            else 
                ({ model | message = "the end!"}, Cmd.none)
        
        NewEmoji em ->
            if Set.member em model.used then
                let 
                    upd = {model | repeats = model.repeats + 1}
                in
                    (upd, newEmoji)
            else 
                let 
                    upd = { model | emoji = em
                            , used = Set.insert em model.used
                            }
                in
                    (upd, Cmd.none)

view : Model -> Document Msg
view model =
    { title = "Random Emoji Storybuilder"
    , body =
        [ div []
            [
            div [] [ text <| String.fromChar <| model.emoji ]
            , button [ onClick <| GetEmoji  ] [ text "Get Random Emoji" ]
            , div [] [ text <| "Repeats: " ++ (String.fromInt model.repeats) ]
            , div [] [ text model.message ] 
            ]
        ]
    } 

type alias Document msg =
    { title : String
    , body : List (Html msg)
    }

main : Program () Model Msg
main =
    Browser.document
        { init = initialModel
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
