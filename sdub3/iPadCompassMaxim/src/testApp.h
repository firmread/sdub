#pragma once

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"
#include "ofxMaxim.h"

class testApp : public ofxiPhoneApp {
	
public:
    
	~testApp();
	void setup();
	void update();
	void draw();

	void touchDown(ofTouchEventArgs &touch);
	void touchMoved(ofTouchEventArgs &touch);
	void touchUp(ofTouchEventArgs &touch);
	void touchDoubleTap(ofTouchEventArgs &touch);
	void touchCancelled(ofTouchEventArgs &touch);
	
	void exit();
	void lostFocus();
	void gotFocus();
	void gotMemoryWarning();
	void deviceOrientationChanged(int newOrientation);
	
    //------------------------------------sound
    void audioReceived( float * input, int bufferSize, int nChannels );
	void audioRequested( float * output, int bufferSize, int nChannels );
	
	int		initialBufferSize;
	int		sampleRate;
    int     absxy,absxy1;
	
	
	ofxMaxiOsc myOsc1;
	ofxMaxiSample sample1,atmosample1;
	double wave,sample,atmosample,outputs1[2];
	ofxMaxiMix channel1;
    
    
    //------------------------------------compass
	ofxiPhoneCoreLocation * coreLocation;
	
	float heading;
    float sinheading;
	
	bool hasCompass;
	bool hasGPS;
	
	ofImage arrowImg;
	ofImage compassImg;
};
