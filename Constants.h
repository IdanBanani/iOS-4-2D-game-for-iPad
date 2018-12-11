//
//  Constants.h
//  

#define kBallTagValue 0
#define kTrampolinTagValue 1
#define kMonsterTagValue 2
#define kEyeTagValue 3
#define kCannonTagValue 4
#define kObstacleTagValue 5
#define kBallsLeftTagValue 6
#define PTM_RATIO 100 
#define kMainMenuTagValue 10
#define kSceneMenuTagValue 20

typedef enum 
{
    kNoSceneUninitialized=0,
    kMainMenuScene=1,
    kOptionsScene=2,
    kCreditsScene=3,
    kWorldsScene=4,
    kWonLevel=5,
    kLostLevel=6,
    kLevelMenuScene=7,

    kGameLevel1=101,
    kGameLevel2=102,
    kGameLevel3=103,
    kGameLevel4=104,
} SceneTypes;

// Audio Items
#define AUDIO_MAX_WAITTIME 150

typedef enum 
{
    kAudioManagerUninitialized=0,
    kAudioManagerFailed=1,
    kAudioManagerInitializing=2,
    kAudioManagerInitialized=100,
    kAudioManagerLoading=200,
    kAudioManagerReady=300
    
} GameManagerSoundState;

// Audio Constants
#define SFX_NOTLOADED NO
#define SFX_LOADED YES

#define PLAYSOUNDEFFECT(...) \
[[GameManager sharedGameManager] playSoundEffect:@#__VA_ARGS__]

#define STOPSOUNDEFFECT(...) \
[[GameManager sharedGameManager] stopSoundEffect:__VA_ARGS__]

// Background Music
// Menu Scenes
#define BACKGROUND_TRACK_MAIN_MENU @"fuse2.caf"

