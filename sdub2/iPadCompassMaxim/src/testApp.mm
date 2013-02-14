#include "testApp.h"
#include "ofxMaxim.h"

testApp::~testApp() {
	delete sample1.myData;
    delete atmosample1.myData;
    
}

//--------------------------------------------------------------
void testApp::setup(){
	ofBackground(225, 225, 225);

	// register touch events
	ofRegisterTouchEvents(this);
	
	// initialize the accelerometer
	ofxAccelerometer.setup();
	
	//iPhoneAlerts will be sent to this.
	ofxiPhoneAlerts.addListener(this);
    
    ofSetCircleResolution(100);
    
    //------------------------------------sound
    sampleRate 			= 44100;
	initialBufferSize	= 512;
	
	sample1.load(ofToDataPath("beat2.wav"));
    sample1.getLength();
    
    atmosample1.load(ofToDataPath("remoteatmos.wav"));
    atmosample1.getLength();
    
	ofSoundStreamSetup(2,0,this, sampleRate, initialBufferSize, 4);
    
		
    //------------------------------------compass
	coreLocation = new ofxiPhoneCoreLocation();
	hasCompass = coreLocation->startHeading();
	hasGPS = coreLocation->startLocation();
	
	arrowImg.loadImage("arrowLong.png");
	compassImg.loadImage("compass.png");
	
	compassImg.setAnchorPoint(compassImg.width/2, compassImg.height/2);
	arrowImg.setAnchorPercent(0.5, 1.0);
	
	heading = 0.0;
}


//--------------------------------------------------------------
void testApp::update(){	
	heading     = ofLerpDegrees(heading, -coreLocation->getTrueHeading(), 0.7);
    sinheading  = sin(heading*PI/180);
    absxy       = abs(mouseX+mouseY);
    absxy1      = ofMap(absxy, 0, ofGetWidth()+ofGetHeight(), -1, 1);
    
    
//    cout << sinheading << endl;
}

//--------------------------------------------------------------
void testApp::draw(){
    ofBackground(184, 165, 150);
	ofSetColor(54);
	ofDrawBitmapString("Core Location Example", 16, 20);
    ofDrawBitmapString("Sine Heading", 16, 90);
    ofDrawBitmapString(ofToString(sin(heading*PI/180)), 130, 90);

	ofEnableAlphaBlending();	
	ofSetColor(255);
		ofPushMatrix();	
        ofTranslate(ofGetWidth()/8, ofGetHeight()*7/8, 0);
        ofRotateZ(heading);
        ofCircle(0, 0, sample*1000);
		compassImg.draw(0,0);
        ofPopMatrix();
	
	ofSetColor(255);
	arrowImg.draw(ofGetWidth()/8, ofGetHeight()*7/8);	

	ofSetColor(54);
        ofPushMatrix();
        ofScale(2,2);
        ofDrawBitmapString("LAT: ", 8, 22);
        ofDrawBitmapString("LON: ", 8, 36);
        
        if(hasGPS){
            cout<<coreLocation->getLatitude()<<" | "<< coreLocation->getLatitude() <<endl;
            
            ofSetHexColor(0x009d88);
            ofDrawBitmapString(ofToString(coreLocation->getLatitude()), 8 + 33, 22);

            ofSetHexColor(0x0f7941d);
            ofDrawBitmapString(ofToString(coreLocation->getLongitude()), 8 + 33, 36);
            
        }
        ofPopMatrix();
}
//--------------------------------------------------------------
void testApp::audioRequested(float * output, int bufferSize, int nChannels){
	
	if( initialBufferSize != bufferSize ){
		ofLog(OF_LOG_ERROR, "your buffer size was set to %i - but the stream needs a buffer size of %i", initialBufferSize, bufferSize);
		return;
	}	
	
	for (int i = 0; i < bufferSize; i++){
		
//		sample  =   sample1.play(1.);
        sample  =   sample1.play(sinheading,0,sample1.length);
        atmosample = atmosample1.play(1.);
        
//        wave    =   myOsc1.sinebuf(absxy);
		
        channel1.stereo(sample + atmosample, outputs1, 0.3);
		
		output[i*nChannels    ] = outputs1[0];
		output[i*nChannels + 1] = outputs1[1];
		
	}
	
}

//--------------------------------------------------------------
void testApp::audioReceived(float * input, int bufferSize, int nChannels){
	
}


//--------------------------------------------------------------
void testApp::exit(){
}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs &touch){
}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs &touch){
}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs &touch){
}

//--------------------------------------------------------------
void testApp::touchDoubleTap(ofTouchEventArgs &touch){
}

//--------------------------------------------------------------
void testApp::lostFocus() {
}

//--------------------------------------------------------------
void testApp::gotFocus() {
}

//--------------------------------------------------------------
void testApp::gotMemoryWarning() {
}

//--------------------------------------------------------------
void testApp::deviceOrientationChanged(int newOrientation){
}



//--------------------------------------------------------------
void testApp::touchCancelled(ofTouchEventArgs& args){

}

