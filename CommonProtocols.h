//
//  CommonProtocols.h
//

typedef enum 
{
    kStateSpawning,
    kStateBallFired,
    kStateBallHitTrampolin,
    kStateBallHitMonster,
    kStateDead
} CharacterStates;


typedef enum 
{
    kObjectTypeNone,
    kBalltype,
    kTrampolinType,
    kObstacleType,
    kMonsterType,
    kEyeType,
    kCannonType,
    kMovingAnimalType
} GameObjectType;
