module Pages.Home exposing (view, Msg, update, init, Model)

import Html exposing (Html, Attribute, h1, h2, map, text, div, ul, p, button, a)
import Html.Attributes exposing (class, href)
import Html.Events exposing (..)

import Header
import Footer
import Listing.Categories as Categories

type alias Model =
    { 
        header: Header.Model
        , footer: Footer.Model
        , categories: Categories.Model
    }

init : ( Model, Cmd Msg )
init =
    ( { header = Header.init
      , footer = Footer.init
      , categories = Categories.init
      }, Cmd.none )

type Msg 
    = HeaderMsg Header.Msg
    | FooterMsg Footer.Msg
    | CategoriesMsg Categories.Msg

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
    HeaderMsg headerMsg ->
        ( { model | header = Header.update headerMsg model.header }, Cmd.none )

    FooterMsg footerMsg ->
        ( { model | footer = Footer.update footerMsg model.footer }, Cmd.none )
    
    CategoriesMsg categoriesMsg ->
        ( { model | categories = Categories.update categoriesMsg model.categories }, Cmd.none )

view : Model -> Html Msg
view model =
    let
        setCategories = CategoriesMsg (Categories.SetCategories [{ id = 4,
            name = "Mange",
            description = "Des mangas",
            createdAt = "2020-05-27T16:43:58.0149453Z",
            updatedAt = "2020-05-27T16:43:58.0149453Z"
            }])
    in
        div[]
        [
            map HeaderMsg (Header.view model.header)
            , div[class "content"]
            [
                
                div []
                    [ 
                        h1 [] [ text "Page home" ] 
                    ]
                , h2 [] [text "Dernières catégories ajoutées"]
                , map CategoriesMsg (Categories.view model.categories)
                , button [ onClick setCategories ] [ text "Categories suivantes" ]
            ]
            , map FooterMsg (Footer.view model.footer)
        ]
        