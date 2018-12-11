//
//  GameManager.m
//

#import "GameManager.h"
#import "MainMenuScene.h"
#import "OptionsScene.h"
#import "CreditScene.h"
#import "WorldsScene.h"
#import "SceneWon.h"
#import "SceneLost.h"
#import "LevelMenuScene.h"
#import "Scene1.h"
#import "Scene2.h"
#import "Scene3.h"
#import "Scene4.h"


@implementation GameManager
static GameManager* _sharedGameManager = nil; //static!                    
@synthesize isPlayingFirstTime;
@synthesize isMusicON;
@synthesize isSoundEffectsON;
@synthesize isGameOver;
@synthesize lastScene;
@synthesize hasAudioBeenInitialized;
@synthesize managerSoundState;
@synthesize listOfSoundEffectFiles;
@synthesize soundEffectsState;


+(GameManager*) sharedGameManager  //C'tor for the static _sharedGameManager
{
    @synchronized([GameManager class])                             
    {
        if(!_sharedGameManager)                                    
            [[self alloc] init]; 
        return _sharedGameManager;                                 
    }
    return nil; 
}

+(id) alloc 
{
    @synchronized ([GameManager class])                            
    {
        NSAssert(_sharedGameManager == nil, @"Attempted to allocated a second instance of the Game Manager singleton");  
        _sharedGameManager = [super alloc];
        return _sharedGameManager;                                 
    }
    return nil;  
}

-(id) init 
{                                               
    self = [super init];
    if (self != nil) 
    {
        // Game Manager initialized
        CCLOG(@"Game Manager Singleton, init");
        isMusicON = YES;
        isSoundEffectsON = YES;
        isGameOver = NO;
        currentScene = kNoSceneUninitialized;
        isPlayingFirstTime = YES;
        hasAudioBeenInitialized = NO;
        soundEngine = nil;
        managerSoundState = kAudioManagerUninitialized;
    }
    return self;
}

-(CGSize) getDimensionsOfCurrentScene 
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CGSize levelSize;
    switch (currentScene) {
        case kMainMenuScene: 
        case kOptionsScene:
        case kCreditsScene:
        case kWorldsScene:
        case kLevelMenuScene:
        case kWonLevel:
        case kLostLevel:
        case kGameLevel1: 
        case kGameLevel2:
        case kGameLevel3:
        case kGameLevel4:
            levelSize = screenSize; //same for all scenes
        break;
            
        default:
            CCLOG(@"Unknown Scene ID, returning default size");
            levelSize = screenSize;
            break;
    }
    return levelSize;
}



-(void) playBackgroundTrack:(NSString*)trackFileName 
{
    // Wait to make sure soundEngine is initialized
    if ((managerSoundState != kAudioManagerReady) && (managerSoundState != kAudioManagerFailed)) 
    {
        int waitCycles = 0;
        while (waitCycles < AUDIO_MAX_WAITTIME) 
        {
            [NSThread sleepForTimeInterval:0.1f];
            if ((managerSoundState == kAudioManagerReady) || (managerSoundState == kAudioManagerFailed)) 
            {
                break;
            }
            waitCycles = waitCycles + 1;
        }
    }
    
    //finished waiting
    if (managerSoundState == kAudioManagerReady) 
    {
        if ([soundEngine isBackgroundMusicPlaying]) 
        {
            [soundEngine stopBackgroundMusic]; //this method overrides the previous playing track
        }
        [soundEngine preloadBackgroundMusic:trackFileName]; //load
        [soundEngine playBackgroundMusic:trackFileName loop:YES]; //play
    }
}

-(void) stopSoundEffect:(ALuint)soundEffectID 
{
    if (managerSoundState == kAudioManagerReady) 
    {
        [soundEngine stopEffect:soundEffectID]; //disable a sound effect
    }
}

-(ALuint) playSoundEffect:(NSString*)soundEffectKey 
{
    if (isSoundEffectsON) //we should load all the sound effects from a plist file 
    {
        ALuint soundID = 0;
        if (managerSoundState == kAudioManagerReady) 
        {
            NSNumber *isSFXLoaded = [soundEffectsState objectForKey:soundEffectKey];
            if ([isSFXLoaded boolValue] == SFX_LOADED) 
            {
                soundID = [soundEngine playEffect:[listOfSoundEffectFiles objectForKey:soundEffectKey]];
            } 
            else 
            {
                CCLOG(@"GameMgr: SoundEffect %@ is not loaded, cannot play.",soundEffectKey);
            }
        } 
        else 
        {
            CCLOG(@"GameMgr: Sound Manager is not ready, cannot play %@", soundEffectKey);
        }
        return soundID; 
    }
    return 0;
}

-(NSString*) formatSceneTypeToString:(SceneTypes)sceneID 
{
    NSString *result = nil;
    switch(sceneID) 
    {
        case kNoSceneUninitialized:
            result = @"kNoSceneUninitialized";
            break;
        case kMainMenuScene:
            result = @"kMainMenuScene";
            break;
        case kOptionsScene:
            result = @"kOptionsScene";
            break;
        case kCreditsScene:
            result = @"kCreditsScene";
            break;
        case kWorldsScene:
            result = @"kWorldsScene";
            break;
        case kWonLevel:
            result = @"kWonLevel";
            break;
        case kLostLevel:
            result = @"kLostLevel";
            break;
        case kLevelMenuScene:
            result = @"kLevelMenuScene";
            break;
        case kGameLevel1:
            result = @"kGameLevel1";
            break;
        case kGameLevel2:
            result = @"kGameLevel2";
            break;
        case kGameLevel3:
            result = @"kGameLevel3";
            break;
        case kGameLevel4:
            result = @"kGameLevel4";
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected SceneType."];
    }
    return result;
}

-(NSDictionary*) getSoundEffectsListForSceneWithID:(SceneTypes)sceneID 
{
    NSString *fullFileName = @"soundEffects.plist"; //we have only one SFX plist
    NSString *plistPath;
    
    // Get the Path to the plist file
    NSString *rootPath = 
    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                         NSUserDomainMask, YES) 
     objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:fullFileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) 
    {
        plistPath = [[NSBundle mainBundle] 
                     pathForResource:@"soundEffects" ofType:@"plist"];
    }
    
    // Read in the plist file
    NSDictionary *plistDictionary = 
    [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    // If the plistDictionary was null, the file was not found.
    if (plistDictionary == nil) 
    {
        CCLOG(@"Error reading soundEffects.plist");
        return nil; // No Plist Dictionary or file found
    }
    
    // If the list of soundEffectFiles is empty, load it
    if ((listOfSoundEffectFiles == nil) || ([listOfSoundEffectFiles count] < 1)) 
    {
        [self setListOfSoundEffectFiles:
        [[NSMutableDictionary alloc] init]];
        for (NSString *sceneSoundDictionary in plistDictionary)
        {
            [listOfSoundEffectFiles 
             addEntriesFromDictionary:
             [plistDictionary objectForKey:sceneSoundDictionary]];
        }
        CCLOG(@"Number of SFX filenames:%d", 
              [listOfSoundEffectFiles count]);
    }
    
    // Load the list of sound effects state, mark them as unloaded
    if ((soundEffectsState == nil) || 
        ([soundEffectsState count] < 1))
    {
        [self setSoundEffectsState:[[NSMutableDictionary alloc] init]];
        for (NSString *SoundEffectKey in listOfSoundEffectFiles)
        {
            [soundEffectsState setObject:[NSNumber numberWithBool:SFX_NOTLOADED] forKey:SoundEffectKey];
        }
    }
    
    // Return just the mini SFX list for this scene
    NSString *sceneIDName = [self formatSceneTypeToString:kGameLevel1]; 
    NSDictionary *soundEffectsList = 
    [plistDictionary objectForKey:sceneIDName];
    
    return soundEffectsList;
}


-(void) loadAudioForSceneWithID:(NSNumber*)sceneIDNumber 
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init]; 
    
    SceneTypes sceneID = (SceneTypes)[sceneIDNumber intValue];

    //wait till it is possible to load the audio
    if (managerSoundState == kAudioManagerInitializing) 
    {
        int waitCycles = 0;
        while (waitCycles < AUDIO_MAX_WAITTIME)
        {
            [NSThread sleepForTimeInterval:0.1f];
            if ((managerSoundState == kAudioManagerReady) || (managerSoundState == kAudioManagerFailed))
            {
                break;
            }
            waitCycles = waitCycles + 1;
        }
    }
    
    if (managerSoundState == kAudioManagerFailed)
    {
        return; // Nothing to load, CocosDenshion not ready
    }
    
    NSDictionary *soundEffectsToLoad = 
    [self getSoundEffectsListForSceneWithID:sceneID];
    if (soundEffectsToLoad == nil) { 
        CCLOG(@"Error reading SoundEffects.plist");
        return;
    }
    // Get all of the entries and PreLoad 
    for( NSString *keyString in soundEffectsToLoad )
    {
        CCLOG(@"\nLoading Audio Key:%@ File:%@",keyString,[soundEffectsToLoad objectForKey:keyString]);
        [soundEngine preloadEffect:[soundEffectsToLoad objectForKey:keyString]]; 
        [soundEffectsState setObject:[NSNumber numberWithBool:SFX_LOADED] forKey:keyString];
        
    }
    [pool release];
}

-(void) unloadAudioForSceneWithID:(NSNumber*)sceneIDNumber 
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    SceneTypes sceneID = (SceneTypes)[sceneIDNumber intValue];
    if (sceneID == kNoSceneUninitialized) 
    {
        return; // Nothing to unload
    }
    
    
    NSDictionary *soundEffectsToUnload = 
    [self getSoundEffectsListForSceneWithID:sceneID];
    if (soundEffectsToUnload == nil) {
        CCLOG(@"Error reading SoundEffects.plist");
        return;
    }
    if (managerSoundState == kAudioManagerReady) {
        // Get all of the entries and unload
        for( NSString *keyString in soundEffectsToUnload )
        {
            [soundEffectsState setObject:[NSNumber numberWithBool:SFX_NOTLOADED] forKey:keyString];
            [soundEngine unloadEffect:keyString];
            CCLOG(@"\nUnloading Audio Key:%@ File:%@", keyString,[soundEffectsToUnload objectForKey:keyString]);
            
        }
    }
    [pool release];
}

-(void) initAudioAsync 
{
    // Initializes the audio engine asynchronously
    managerSoundState = kAudioManagerInitializing; 
    // Indicate that we are trying to start up the Audio Manager
    [CDSoundEngine setMixerSampleRate:CD_SAMPLE_RATE_MID];
    
    //Init audio manager asynchronously as it can take a few seconds
    //The FXPlusMusicIfNoOtherAudio mode will check if the user is
    // playing music and disable background music playback if 
    // that is the case.
    [CDAudioManager initAsynchronously:kAMM_FxPlusMusicIfNoOtherAudio];
    
    //Wait for the audio manager to initialise
    while ([CDAudioManager sharedManagerState] != kAMStateInitialised) 
    {
        [NSThread sleepForTimeInterval:0.1];
    }
    
    //At this point the CocosDenshion should be initialized
    // Grab the CDAudioManager and check the state
    CDAudioManager *audioManager = [CDAudioManager sharedManager];
    if (audioManager.soundEngine == nil || audioManager.soundEngine.functioning == NO) 
    {
        CCLOG(@"CocosDenshion failed to init, no audio will play.");
        managerSoundState = kAudioManagerFailed; 
    } 
    else 
    {
        [audioManager setResignBehavior:kAMRBStopPlay autoHandle:YES];
        soundEngine = [SimpleAudioEngine sharedEngine];
        managerSoundState = kAudioManagerReady;
        CCLOG(@"CocosDenshion is Ready");
    }
}


-(void) setupAudioEngine 
{
    if (hasAudioBeenInitialized == YES) 
    {
        return;
    } 
    else 
    {
        hasAudioBeenInitialized = YES; 
        NSOperationQueue *queue = [[NSOperationQueue new] autorelease];
        NSInvocationOperation *asyncSetupOperation = 
        [[NSInvocationOperation alloc] initWithTarget:self 
                                             selector:@selector(initAudioAsync) 
                                               object:nil];
        [queue addOperation:asyncSetupOperation];
        [asyncSetupOperation autorelease];
    }
}

-(void) runSceneWithID:(SceneTypes)sceneID andScore:(int)score 
{
    lastScene = currentScene;
    SceneTypes oldScene = currentScene;
    currentScene = sceneID;
    
    id sceneToRun = nil;
    switch (sceneID) {
        case kMainMenuScene: 
            sceneToRun = [MainMenuScene node];
            break;
        case kLevelMenuScene: 
            sceneToRun = [LevelMenuScene node];
            break;
        case kOptionsScene:
        {
            sceneToRun = [OptionsScene node];
        }
            break;
        case kCreditsScene: 
            sceneToRun = [CreditScene node];
            break;
        case kWorldsScene: 
            sceneToRun = [WorldsScene node];
            break;
        case kWonLevel: 
        {
            SceneWon* win = [SceneWon alloc];
            [win initWithPoints:score];
            sceneToRun = win;
        }
            break;
        case kLostLevel: 
            sceneToRun = [SceneLost node];
            break;
        case kGameLevel1: 
            sceneToRun = [Scene1 node];
            break;
        case kGameLevel2: 
            sceneToRun = [Scene2 node];
            break;
        case kGameLevel3: 
            sceneToRun = [Scene3 node];
            break;
        case kGameLevel4: 
            sceneToRun = [Scene4 node]; 
            break;                
        default:
            CCLOG(@"Unknown ID, cannot switch scenes");
            return;
            break;
    }
    
    if (sceneToRun == nil) 
    {
        // Revert back, since no new scene was found
        currentScene = oldScene;
        return;
    }
    
    //unload the sound effects of the old scene 
    [self performSelectorInBackground:@selector(unloadAudioForSceneWithID:) withObject:[NSNumber numberWithInt:oldScene]];

    //load the sound effects for the new scene
    if (sceneID==kGameLevel1 || sceneID==kGameLevel2 || sceneID==kGameLevel3 || sceneID==kGameLevel4) 
    {
        [self performSelectorInBackground:@selector(loadAudioForSceneWithID:) 
                               withObject:[NSNumber numberWithInt:currentScene]];
    }
    
    
    if ([[CCDirector sharedDirector] runningScene] == nil) 
    {
        [[CCDirector sharedDirector] runWithScene:sceneToRun];
        
    } 
    else
    {
        [[CCDirector sharedDirector] replaceScene:sceneToRun];
    }
    
    
    currentScene = sceneID;
}


@end