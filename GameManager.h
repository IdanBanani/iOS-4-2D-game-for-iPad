//  
// GameManager.h 
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "SimpleAudioEngine.h"

@interface GameManager : NSObject 
{
    BOOL isPlayingFirstTime;
    BOOL isGameOver;
    SceneTypes currentScene;
    SceneTypes lastScene;
     
    // Added for audio
    BOOL isMusicON;
    BOOL isSoundEffectsON;
    BOOL hasAudioBeenInitialized;
    
    GameManagerSoundState managerSoundState;
    SimpleAudioEngine *soundEngine;
    NSMutableDictionary *listOfSoundEffectFiles;
    NSMutableDictionary *soundEffectsState;
}
@property (readwrite) BOOL isPlayingFirstTime;
@property (readwrite) BOOL isGameOver;
@property (readwrite) SceneTypes lastScene;
@property (readwrite) BOOL isMusicON;
@property (readwrite) BOOL isSoundEffectsON;



@property (readwrite) BOOL hasAudioBeenInitialized;
@property (readwrite) GameManagerSoundState managerSoundState;
@property (nonatomic, retain) NSMutableDictionary *listOfSoundEffectFiles;
@property (nonatomic, retain) NSMutableDictionary *soundEffectsState;

//In this project we Call those methods very often from other classes
+(GameManager*) sharedGameManager;                                  
-(NSString*) formatSceneTypeToString:(SceneTypes)sceneID;
-(void) runSceneWithID:(SceneTypes)sceneID andScore:(int)score;       
-(void)setupAudioEngine;
-(ALuint) playSoundEffect:(NSString*)soundEffectKey;
-(void) stopSoundEffect:(ALuint)soundEffectID;
-(void) playBackgroundTrack:(NSString*)trackFileName;
-(CGSize) getDimensionsOfCurrentScene;
@end