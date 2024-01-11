#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

MAIN_MENU() {
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT_INFO_RESULT=$($PSQL "SELECT atomic_number, e.symbol, e.name, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements AS e INNER JOIN properties AS p USING(atomic_number) INNER JOIN types AS t USING(type_id) WHERE atomic_number=$1")
  elif [[ $1 =~ ^[a-zA-Z]{1,2}$ ]]
  then
    ELEMENT_INFO_RESULT=$($PSQL "SELECT atomic_number, e.symbol, e.name, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements AS e INNER JOIN properties AS p USING(atomic_number) INNER JOIN types AS t USING(type_id) WHERE e.symbol ILIKE '$1'")
  elif [[ $(echo $1 | wc -m) -gt 2 && $1 =~ ^[a-zA-Z]+$ ]]
  then
    ELEMENT_INFO_RESULT=$($PSQL "SELECT atomic_number, e.symbol, e.name, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements AS e INNER JOIN properties AS p USING(atomic_number) INNER JOIN types AS t USING(type_id) WHERE e.name ILIKE '$1'")
  else
    echo "I could not find that element in the database."
    return
  fi

  if [[ -z $ELEMENT_INFO_RESULT ]]
  then
    echo "I could not find that element in the database."
  else
    ELEMENT_INFO_RESULT=$(echo $ELEMENT_INFO_RESULT | sed 's/ //g')
    echo $ELEMENT_INFO_RESULT | while IFS="|" read ATOMIC_NUMBER SYMBOL NAME TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
}

MAIN_MENU $1
