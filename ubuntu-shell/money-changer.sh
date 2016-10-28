#!/bin/bash

#############################################################
#					Simple Change Machine					#
#############################################################
# author: ryan wheaton (ryan.wheaton@gmail.com)				#
# requires: 												#
#			bc for floating point calcs						#
#			awk for floating point to int conversion		#
#############################################################

# function takes multiple args to be converted to ints using 
# builtin awk vars ARGC & ARGV then use format specifier to 
# set precision
float2int() {
	awk 'BEGIN{for (i=1; i<ARGC;i++)
	printf "%.0f\n", ARGV[i]}' "$@"
}

main(){

	clear
	echo "Enter how much do you need changed, followed by [ENTER]:"

	read amount

	# remove any commas from the number that a user may enter
	amount=$(echo $amount | tr -d ",")

	# make sure the user entered a number, check via regex
	valid_re='^[0-9]+([.][0-9]+)?$'
	if ! [[ $amount =~ $valid_re ]] ; then
		# if not, try again
		echo "ERROR: Please enter a number, using only digits and decimals" >&2; main
	fi

	# bash doesn't handle floats, so lets delegate to bc and then use awk for int conversion
	amountCents=$(float2int $(echo "100*$amount" | bc))

	hundredSpot=$(( $amountCents / 10000 ))
	fiftySpot=$(( $amountCents % 10000 / 5000 ))
	twentySpot=$(( $amountCents % 10000 % 5000 / 2000 ))
	tenSpot=$(( $amountCents % 10000 % 5000 % 2000 / 1000 ))
	fiveSpot=$(( $amountCents % 10000 % 5000 % 2000 % 1000 / 500 ))
	twoSpot=$(( $amountCents % 10000 % 5000 % 2000 % 1000 % 500 / 200 ))
	oneSpot=$(( $amountCents % 10000 % 5000 % 2000 % 1000 % 500 % 200 / 100 ))
	halfSpot=$(( $amountCents % 10000 % 5000 % 2000 % 1000 % 500 % 200 % 100 / 50 ))
	quarters=$(( $amountCents % 10000 % 5000 % 2000 % 1000 % 500 % 200 % 100 % 50 / 25 ))
	dimes=$(( $amountCents % 10000 % 5000 % 2000 % 1000 % 500 % 200 % 100 % 50 % 25 / 10 ))
	nickels=$(( $amountCents % 10000 % 5000 % 2000 % 1000 % 500 % 200 % 100 % 50 % 25 % 10 / 5 ))
	pennies=$(( $amountCents % 10000 % 5000 % 2000 % 1000 % 500 % 200 % 100 % 50 % 25 % 10 % 5 / 1 ))

	echo "The following denominations are to be dispensed:"

	if [[ "$hundredSpot" != 0 ]] ; then
		echo "("$hundredSpot")" "hundreds"
	fi
	if [[ "$fiftySpot" != 0 ]] ; then
		echo "("$fiftySpot")" "fifties"
	fi
	if [[ "$twentySpot" != 0 ]] ; then
		echo "("$twentySpot")" "twenties"
	fi
	if [[ "$tenSpot" != 0 ]] ; then
		echo "("$tenSpot")" "tens"
	fi
	if [[ "$fiveSpot" != 0 ]] ; then	
		echo "("$fiveSpot")" "fives"
	fi
	if [[ "$twoSpot" != 0 ]] ; then
		echo "("$twoSpot")" "twos (must be your lucky day)"
	fi
	if [[ "$oneSpot" != 0 ]] ; then
		echo "("$oneSpot")" "ones"
	fi
	if [[ "$halfSpot" != 0 ]] ; then
		echo "("$halfSpot")" "half dollars"
	fi
	if [[ "$quarters" != 0 ]] ; then
		echo "("$quarters")" "quarters"
	fi
	if [[ "$dimes" != 0 ]] ; then
		echo "("$dimes")" "dimes"
	fi
	if [[ "$nickels" != 0 ]] ; then
		echo "("$nickels")" "nickels"
	fi
	if [[ "$pennies" != 0 ]] ; then
		echo "("$pennies")" "pennies"
	fi

	echo "please take your monies!"
}

main
