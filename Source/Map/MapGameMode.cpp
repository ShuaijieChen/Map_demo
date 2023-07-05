// Copyright Epic Games, Inc. All Rights Reserved.

#include "MapGameMode.h"
#include "MapCharacter.h"
#include "UObject/ConstructorHelpers.h"

AMapGameMode::AMapGameMode()
{
	// set default pawn class to our Blueprinted character
	static ConstructorHelpers::FClassFinder<APawn> PlayerPawnBPClass(TEXT("/Game/ThirdPersonCPP/Blueprints/ThirdPersonCharacter"));
	if (PlayerPawnBPClass.Class != NULL)
	{
		DefaultPawnClass = PlayerPawnBPClass.Class;
	}
}
