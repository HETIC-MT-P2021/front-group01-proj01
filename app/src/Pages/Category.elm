module Pages.Category exposing (view, Msg, update, init, Model)

import Html exposing (Html, Attribute, h1, map, text, div, p, span)
import Html.Attributes exposing (class, href)
import Html.Events exposing (..)

import Header
import Footer

init : Int -> ( Model, Cmd Msg )
init id =
    ( { header = Header.init
      , footer = Footer.init
      , categoryId = id
      , categoryData = Nothing
      , images = []
      }, Cmd.none )

type alias Model =
    { 
        header: Header.Model
        , footer: Footer.Model
        , categoryId: Int
        , categoryData: Maybe Category
        , images: List Image
    }

type alias Image = 
    {
        id: Int
        , name: String
        , description: String
        , tags: List String
        , url: String
    }

type alias Category =
    {
        name: String
        , description: String
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
                    h1 [] [ text "Page de la catégorie"],
                    span [] [text (String.fromInt model.categoryId)]
                ]
            , map FooterMsg (Footer.view model.footer)
        ]