module Pages.Categories exposing (view, Msg, update, init, Model)

import Html exposing (Html, Attribute, h1, map, text, div, p)
import Html.Attributes exposing (class, href)
import Html.Events exposing (..)

import Header
import Footer

init : ( Model, Cmd Msg )
init =
    ( { header = Header.init
      , footer = Footer.init
      }, Cmd.none )

type alias Model =
    { 
        header: Header.Model
        , footer: Footer.Model
    }

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
    div[class "content"]
        [
            map HeaderMsg (Header.view model.header)
            , div []
                [ 
                    h1 [] [ text "Page des catégories" ]
                    ,p [] [ text "Sur cette page seront listés les catégories"] 
                ]
            , map FooterMsg (Footer.view model.footer)
        ]