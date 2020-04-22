module Pages.About exposing (main, view, Msg, update)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


main : Program () Model Msg
main =
    Browser.sandbox
        { init = {title = "About"}
        , view = view
        , update = update
        }

type alias Model =
    { title : String }

type Msg
    = ChangeTitle String

update : Msg -> Model -> Model
update msg model =
    case msg of
        ChangeTitle newTitle ->
            {model | title = newTitle}

view : Model -> Html Msg
view model =
    div[][
        text ( model.title ),br[][]
    ]