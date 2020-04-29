module Pages.Categories exposing (view, Msg, update, init, Model)

import Html exposing (Html, h1, map, text, div, p, table, thead, tbody, tr, td, th, a, button)
import Html.Attributes exposing (class, href, src)
import Html.Events exposing (..)
import Http exposing (Error(..))
import Json.Decode as Decode exposing (Decoder)

import Header
import Footer

type alias Model =
    { 
        header: Header.Model
        , footer: Footer.Model
        , listCategory: List Category
        , error: Maybe String
    }

type alias Category = 
    {
        id : Int
        , name : String
        , description : String
        , createdAt : String
        , updatedAt : String
    }

init : ( Model, Cmd Msg )
init =
    ( { header = Header.init
      , footer = Footer.init
      , listCategory = []
      , error = Nothing
      }, getCategories )

type Msg 
    = HeaderMsg Header.Msg
    | FooterMsg Footer.Msg
    | SendHttpRequest
    | GotItems (Result Http.Error (List Category))

getCategories : Cmd Msg
getCategories = 
    Http.get
    { url = "http://localhost:8080/categories"
    , expect = Http.expectJson GotItems (Decode.list decodeCategory)
    }

decodeCategory : Decoder Category
decodeCategory =
    Decode.map5 Category
        (Decode.field "id" Decode.int)
        (Decode.field "name" Decode.string)
        (Decode.field "description" Decode.string)
        (Decode.field "createdAt" Decode.string)
        (Decode.field "updatedAt" Decode.string)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
    HeaderMsg headerMsg ->
      ( { model | header = Header.update headerMsg model.header }, Cmd.none )

    FooterMsg footerMsg ->
      ( { model | footer = Footer.update footerMsg model.footer }, Cmd.none )

    SendHttpRequest ->
        (model, getCategories)

    GotItems (Ok categories) ->
        ( { model | error = Nothing, listCategory = categories }, Cmd.none )

    GotItems (Err err) ->
        ( { model | error = Just <| errorToString err, listCategory = [] }, Cmd.none )

errorToString : Http.Error -> String
errorToString error =
    case error of
        BadUrl url ->
            "Bad url: " ++ url

        Timeout ->
            "Request timed out."

        NetworkError ->
            "Network error. Are you online?"

        BadStatus status_code ->
            "HTTP error " ++ String.fromInt status_code

        BadBody body ->
            "Unable to parse response body: " ++ body

renderCategory : Category -> Html msg
renderCategory category =
    let
        categoryUrl = "/category/" ++ String.fromInt category.id
    in
        tr[]
        [
            td[] [text (String.fromInt category.id)],
            td[] [text category.name],
            td[] [text category.description],
            td[] [text category.updatedAt],
            td[] [a [href categoryUrl][text "Voir"]]
        ]

renderCategories : List Category -> Html msg
renderCategories categories =
    let 
        category = List.map renderCategory categories
    in
        table [] 
        [
            thead[] 
            [
                tr []
                [
                    th [] [text "Identifiants"],
                    th [] [text "Nom"],
                    th [] [text "Description"],
                    th [] [text "Dernière MAJ"]
                ]
            ],
            tbody [] category
        ]


view : Model -> Html Msg
view model =
    div[] [
        map HeaderMsg (Header.view model.header)
        , div[class "content"]
            [
                div []
                    [ 
                        h1 [] [ text "Page des catégories" ]
                        ,p [] [ text "Sur cette page seront listés les catégories"] 
                        , div [class "categories"]
                        [
                            renderCategories model.listCategory
                        ]
                        ,button [ onClick SendHttpRequest ]
                            [ text "Get data from server" ]
                    ]
            ]
        , map FooterMsg (Footer.view model.footer)
    ]
    