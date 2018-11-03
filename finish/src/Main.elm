module Main exposing (main)

import Browser
import Dict exposing (..)
import Html exposing (Html, button, div, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Random exposing (..)
import Random.Char exposing (..)
import Set exposing (..)


type alias Model =
    { count : Int
    , emoji : Char
    , used : Set Char
    , repeats : Int
    , message : String
    , title : String
    , parts : Dict Int Part
    }

type alias Part =
    { before : Maybe String
    , emoji : Char
    , after : Maybe String
    }


initialModel : flags -> ( Model, Cmd Msg )
initialModel _ =
    let
        m =
            { count = 0, emoji = ' ', used = Set.empty, repeats = 0, message = "", title = "", parts = Dict.empty }
    in
    ( m, Cmd.none )


max =
    30


type Msg
    = GetEmoji
    | NewEmoji Char
    | AddTitle String
    | AddPart Part


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        newEmoji =
            Random.generate NewEmoji Random.Char.emoticon
    in
    case msg of
        GetEmoji ->
            if Set.size model.used < max then
                ( model, newEmoji )

            else
                ( { model | message = "the end!" }, Cmd.none )

        NewEmoji em ->
            if Set.member em model.used then
                let
                    upd =
                        { model | repeats = model.repeats + 1 }
                in
                ( upd, newEmoji )

            else
                let
                    upd =
                        { model
                            | emoji = em
                            , used = Set.insert em model.used
                        }
                in
                ( upd, Cmd.none )

        AddTitle t ->
            let
                m =
                    { model | title = t }
            in
                ( m, Cmd.none )

        AddPart p ->
            ( model, Cmd.none )


view : Model -> Document Msg
view model =
    { title = "Random Emoji Storybuilder"
    , body =
        [ div []
            [ div [] [ text <| String.fromChar <| model.emoji ]
            , button [ onClick <| GetEmoji ] [ text "Get Random Emoji" ]
            , div [] [ text <| "Repeats: " ++ String.fromInt model.repeats ]
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
