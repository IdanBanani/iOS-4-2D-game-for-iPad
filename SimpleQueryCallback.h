//
//  SimpleQueryCallback.h
//  
#import "Box2D.h"

//calss that find if the player touch one of the bodys in the level
class SimpleQueryCallback : public b2QueryCallback
{
public:
    b2Vec2 pointToTest;
    b2Fixture * fixtureFound;
    
    SimpleQueryCallback(const b2Vec2& point) 
    {
        pointToTest = point;
        fixtureFound = NULL;
    }
    
    bool ReportFixture(b2Fixture* fixture) 
    {
       if (fixture->TestPoint(pointToTest))
       {
            fixtureFound = fixture;
            return false;
        }
        return true;
    }        
};
