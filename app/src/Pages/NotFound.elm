module Pages.NotFound exposing (view, Msg, update, init, Model)

import Html exposing (Html, Attribute, h1, map, text, div)
import Html.Attributes exposing (class, href)
import Html.Events exposing (..)

import Header
import Footer

type alias Model =
    { 
        header: Header.Model
        , footer: Footer.Model
    }

init : ( Model, Cmd Msg )
init =
    ( { header = Header.init
      , footer = Footer.init
      }, Cmd.none )

type Msg 
  = HeaderMsg Header.Msg
  | FooterMsg Footer.Msg

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    HeaderMsg headerMsg ->
      ( { model | header = Header.update headerMsg model.header }, Cmd.none )

    FooterMsg footerMsg ->
      ( { model | footer = Footer.update footerMsg model.footer }, Cmd.none )


view : Model -> Html Msg
view model =
    div[]
        [
            map HeaderMsg (Header.view model.header)
            , div []
                [ 
                    h1 [] [ text "404 Not Found" ] 
                ]
            , map FooterMsg (Footer.view model.footer)
        ]