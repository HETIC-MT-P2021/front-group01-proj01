module Pages.About exposing (view, Msg, update, init, Model)

import Html exposing (Html, h1, map, text, div, p)
import Html.Attributes exposing (class)
import Html.Events exposing (..)

import Header
import Footer

init : ( Model, Cmd Msg )
init =
    ( { header = Header.init
      , footer = Footer.init
      }, Cmd.none )

type alias Model =
    { header: Header.Model
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
    div [] 
    [ map HeaderMsg (Header.view model.header)
    , div[class "content"]
        [ div []
            [ h1 [] [ text "Page à propos" ]
            ,p [] [ text "Ceci est projet d'école, nous permettant de découvrir la programmation fonctionnelle grâce au langage ELM" ] 
            ]
        ]
    , map FooterMsg (Footer.view model.footer)
    ]