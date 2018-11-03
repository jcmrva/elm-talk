module Main exposing (main)

import Browser
import Dict exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Random exposing (..)
import Random.Char exposing (..)
import Set exposing (..)
import Values exposing (..)


type alias Model =
    { before : String
    , emoji : Char
    , after : String
    , used : Set Char
    , repeats : Int
    , message : String
    , title : String
    , parts : Dict Int Part
    }


type alias Part =
    { before : String
    , emoji : Char
    , after : String
    }


initialModel : flags -> ( Model, Cmd Msg )
initialModel _ =
    let
        m =
            { emoji = ' '
            , used = Set.empty
            , repeats = 0
            , message = ""
            , title = ""
            , parts = Dict.empty
            , before = ""
            , after = ""
            }
    in
    ( m, Cmd.none )


type Msg
    = GetEmoji
    | NewEmoji Char
    | AddTitle String
    | AddPart String Char String
    | EditPart Part
    | DeletePart Part
    | Cancel
    | GetBefore String
    | GetAfter String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        newEmoji =
            Random.generate NewEmoji Random.Char.emoticon
    in
    case msg of
        GetEmoji ->
            if Set.size model.used < maxEm then
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

        AddPart b em a ->
            let
                part =
                    Part b em a

                upd =
                    { model
                        | parts = Dict.insert (Dict.size model.parts) part model.parts
                        , emoji = ' '
                        , before = ""
                        , after = ""
                    }
            in
            ( upd, Cmd.none )

        Cancel ->
            ( { model | emoji = ' ' }, Cmd.none )

        GetBefore v ->
            ( { model | before = v }, Cmd.none )

        GetAfter v ->
            ( { model | after = v }, Cmd.none )

        _ ->
            ( model, Cmd.none )


view : Model -> Document Msg
view model =
    let
        hasPart =
            not <| Dict.isEmpty model.parts

        ex =
            if hasPart then
                ""

            else
                exampleTxt

        inputOrExample b =
            if b == "" then
                ex

            else
                b

        hasEmoji =
            model.emoji /= ' '

        emojiInput =
            if hasEmoji then
                div []
                    [ input [ maxlength 100, placeholder ex, value model.before, onInput GetBefore ] []
                    , div [] [ text ("[" ++ String.fromChar model.emoji ++ "]") ]
                    , input [ maxlength 100, value model.after, onInput GetAfter ] []
                    , button [ onClick <| AddPart (inputOrExample model.before) model.emoji model.after ] [ text "Add To Story" ]
                    , button [ onClick Cancel ] [ text "Cancel" ]
                    ]

            else
                button [ onClick <| GetEmoji ] [ text "Get Random Emoji" ]

        partsView =
            div [] (Dict.map partView model.parts |> Dict.values |> List.reverse)
    in
    { title = appTitle
    , body =
        [ h2 [] [ text appTitle ]
        , div []
            [ span [] [ text <| "Repeats: " ++ String.fromInt model.repeats ]
            , emojiInput
            , div [] [ text model.message ]
            ]
        , br [] []
        , partsView
        ]
    }


partView : Int -> Part -> Html Msg
partView k p =
    div [ id <| String.fromInt k ] [ text <| p.before ++ String.fromChar p.emoji ++ p.after ]


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
