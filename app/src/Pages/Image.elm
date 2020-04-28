module Pages.Image exposing (view, Msg, update, init, Model)

import Html exposing (Html, h1, map, text, div, span)
import Html.Attributes exposing (class)
import Html.Events exposing (..)

import Header
import Footer

init : Int -> ( Model, Cmd Msg )
init id =
    ( { header = Header.init
      , footer = Footer.init
      , imageId = id
      , imageData = Nothing
      }, Cmd.none )

type alias Model =
    { 
        header: Header.Model
        , footer: Footer.Model
        , imageId: Int
        , imageData: Maybe Image
    }

type alias Image =
    { 
        description: String
        , tags: List String
        , name: String
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
    [   
        map HeaderMsg (Header.view model.header)
        , div[class "content"]
        [
            div []
                [ 
                    h1 [] [ text "Page de l'image"],
                    span [] [text (String.fromInt model.imageId)]
                ]
        ]
        , map FooterMsg (Footer.view model.footer)
    ]