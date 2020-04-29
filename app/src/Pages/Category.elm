module Pages.Category exposing (view, Msg, update, init, Model)

import Html exposing (Html, h1, map, text, div, span)
import Html.Attributes exposing (class)
import Html.Events exposing (..)
import Http exposing (Error(..))
import Json.Decode as Decode exposing (Decoder)

import Header
import Footer

init : Int -> ( Model, Model -> Cmd Msg )
init id =
    ( { header = Header.init
      , footer = Footer.init
      , categoryId = id
      , categoryData = Nothing
      , images = []
      , error = Nothing
      }, getCategory )

type alias Model =
    { 
        header: Header.Model
        , footer: Footer.Model
        , categoryId: Int
        , categoryData: Maybe Category
        , images: List Image
        , error: Maybe String
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
        , createdAt: String
        , updatedAt: String
    }

type Msg 
    = HeaderMsg Header.Msg
    | FooterMsg Footer.Msg
    | GetTheCategory
    | GotItem (Result Http.Error (Category))

getCategory : Model -> Cmd Msg
getCategory model = 
    let
        urlToCall = "http://localhost:8080/categories/" ++ String.fromInt model.categoryId
    in  
        Http.get
        { url = urlToCall
        , expect = Http.expectJson GotItem decodeCategory
        }

decodeCategory : Decoder Category
decodeCategory =
    Decode.map4 Category
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

    GetTheCategory ->
        (model, getCategory model)

    GotItem (Ok category) ->
        ( { model | error = Nothing, categoryData = Just category }, Cmd.none )

    GotItem (Err err) ->
        ( { model | error = Just <| errorToString err, categoryData = Nothing }, Cmd.none )

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


view : Model -> Html Msg
view model =
    div [] 
    [   
        map HeaderMsg (Header.view model.header)
        , div[class "content"]
        [
            div []
                [ 
                    h1 [] [ text "Page de la catégorie"],
                    span [] [text (String.fromInt model.categoryId)]
                ]
        ]
        , map FooterMsg (Footer.view model.footer)
    ]