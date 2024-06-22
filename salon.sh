#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ My Salon ~~~~~~\n"

MAIN_MENU(){

  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  SERVICES=$($PSQL "SELECT * FROM services;")
  echo "$SERVICES" | while read ID BAR NAME;do
      echo  "$ID) $NAME"
  done

  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in 
    [1-3]) SERVICE ;;
    *) MAIN_MENU "Please select a correct opinions" ;;
  esac

}

SERVICE(){

  echo -e "\n\nEnter your phone number."
  read CUSTOMER_PHONE

  NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")

  if [[ -z $NAME ]]
  then
    echo -e "\nNot able to find the you, please enter your name: "
    read CUSTOMER_NAME
    NAME=$(echo $CUSTOMER_NAME | sed 's/ //g')
    echo -e "\nHello $CUSTOMER_NAME, Welcome...."
    ENTRY=$($PSQL "INSERT INTO customers(name,phone) VALUES('$NAME','$CUSTOMER_PHONE');")
  else
    echo -e "\nHello $NAME, Welcome Again...."
  fi

  GET_SERVICE_NAME=$($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED ;")
  SERVICE_NAME=$(echo $GET_SERVICE_NAME | sed 's/ //g')
  echo -e "\nWhat time do you want to take appointment for $SERVICE_NAME: "
  read SERVICE_TIME

  CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")

  MAKE_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES('$CUSTOMER_ID','$SERVICE_ID_SELECTED','$SERVICE_TIME')")

  if [[ $MAKE_APPOINTMENT == "INSERT 0 1" ]]
  then
    echo -e "I have put you down for a $GET_SERVICE_NAME at $SERVICE_TIME, $NAME."
  fi




}

MAIN_MENU
