#include "testApp.h"

testApp::~testApp() {
	
//	delete beatSamp.myData;
//    delete samp2.myData;
	
}


//--------------------------------------------------------------
void testApp::setup(){
	ofEnableAlphaBlending();
	// register touch events
	ofRegisterTouchEvents(this);
	
	// initialize the accelerometer
	ofxAccelerometer.setup();
	
	//iPhoneAlerts will be sent to this.
	ofxiPhoneAlerts.addListener(this);
	
    //sound stuffs
	sampleRate 			= 44100;
	initialBufferSize	= 512;
	drawCounter			= 0;
	bufferCounter		= 0;
    
    lAudioOut			= new float[initialBufferSize];/* outputs */
	rAudioOut			= new float[initialBufferSize];
	lAudioIn			= new float[initialBufferSize];/* inputs */
	rAudioIn			= new float[initialBufferSize];
    
	memset(lAudioOut, 0, initialBufferSize * sizeof(float));
	memset(rAudioOut, 0, initialBufferSize * sizeof(float));
	memset(lAudioIn, 0, initialBufferSize * sizeof(float));
	memset(rAudioIn, 0, initialBufferSize * sizeof(float));
	
	beatSamp.load(ofToDataPath("beat2.wav"));
    samp2.load(ofToDataPath("24620__anamorphosis__GMB_Kantilan_1.wav"));
    
	ts = new maxiPitchStretch<grainPlayerWin>(&samp2);
	stretches.push_back(ts);
    speed       = 1;
    rate        = 2;
	grainLength = 0.05;
	current     = 0;
    
	fft.setup(1024, 512, 256);
	oct.setup(44100, 1024, 10);
	
	ofxMaxiSettings::setup(sampleRate, 2, initialBufferSize);
    
	ofSoundStreamSetup(2,1,this, sampleRate, initialBufferSize, 4);
	ofSetFrameRate(60);
	
	//If you want a landscape oreintation 
	//iPhoneSetOrientation(OFXIPHONE_ORIENTATION_LANDSCAPE_RIGHT);
	
	ofBackground(100,100,100);
    
    
    //Image
    imgSketch.loadImage("padUI.png");
    imgCompass.loadImage("compass.png");
    imgLogo.loadImage("logoyellow.png");
    
    //variables
    beat1 = 120;
    beat2 = 120;
    
    //compass
	coreLocation = new ofxiPhoneCoreLocation();
	hasCompass = coreLocation->startHeading();
	hasGPS = coreLocation->startLocation();
	
	imgCompass.setAnchorPoint(imgCompass.width/2, imgCompass.height/2);
	heading = 0.0;

    
    
    //UI
	float dim = 30; 
	float xInit = OFX_UI_GLOBAL_WIDGET_SPACING; 
    float length = 270-xInit; 
	
    drawPadding = false; 
    
    
    //gui1 beat
    gui1 = new ofxUICanvas(50,100,length+xInit,150);     
	
    gui1->addWidgetDown(new ofxUILabel("BEAT IN", OFX_UI_FONT_MEDIUM)); 	
    gui1->addWidgetDown(new ofxUISlider(length-xInit,dim, 60, 240, beat1, "Beat in 1")); 
	gui1->addWidgetDown(new ofxUISlider(length-xInit,dim, 60, 240, beat2, "Beat in 2")); 
    
    ofAddListener(gui1->newGUIEvent,this,&testApp::guiEvent);
    
    
    //gui2 city
    gui2 = new ofxUICanvas(50,500,length+xInit,250);     
    
	gui2->addWidgetDown(new ofxUILabel("COMPASS", OFX_UI_FONT_MEDIUM)); 
	gui2->addWidgetDown(new ofxUI2DPad(length-xInit,160, ofPoint((length-xInit)*.5,190*.5), "NEW YORK")); 	
	gui2->addWidgetDown(new ofxUILabel("CITY", OFX_UI_FONT_MEDIUM)); 
    
    ofAddListener(gui2->newGUIEvent,this,&testApp::guiEvent);	
    
    
    //gui3 world
    float length2 = 680-xInit;
    gui3 = new ofxUICanvas(50,780,length2+xInit,200);  
	gui3->addWidgetDown(new ofxUI2DPad(length2-xInit,160, ofPoint((length2-xInit)*.5,190*.5), "LAT.LONG")); 	
	gui3->addWidgetDown(new ofxUILabel("WORLD", OFX_UI_FONT_MEDIUM)); 
    
    ofAddListener(gui3->newGUIEvent,this,&testApp::guiEvent);
}

//--------------------------------------------------------------
void testApp::update(){

    //compass
	heading     = ofLerpDegrees(heading, -coreLocation->getTrueHeading(), 0.7);
    sinheading  = sin(heading*PI/180);
    
    int head180 = ((int)heading)%180;
    
    if (head180 > 0) {
        goDirection = ofMap(head180, 0, 180, 250, 400);
    }
    
    if (head180 < 0) {
        goDirection = ofMap(head180, -180, 0, 400, 250);
    }
    cout << heading <<endl;
    
    beatbar = ofMap(beat1,60,240,.5,2);
}

//--------------------------------------------------------------
void testApp::draw(){
    ofEnableAlphaBlending();
    
    //Grid
    ofSetColor(255, 255, 255, 25);	
    drawGrid(10,10);
    ofSetColor(255, 255, 255, 50);	
    drawGrid(50,50); 
    ofSetColor(255, 255, 255, 65);	
    drawGrid(100,100); 
    
    //sketch
    ofSetColor(255, 255, 255,100);
    imgSketch.draw(0,0);
    
    //logo
    ofSetColor(255, 255, 255, 255);
    imgLogo.draw(50, 30, 200, 200*(.328));
    
    
    //wave
    ofPushMatrix();
        ofTranslate(350, 300, 0);
        ofScale(1.484 , 0.4);
        
        // draw the input:
        ofSetColor(255, 255, 255,100);
        ofRect(0,0,256,200);
        ofSetColor(255, 255, 255);
        for (int i = 0; i < initialBufferSize/2; i++){
            ofLine(i,100,i,100+lAudioIn[i]*100.0f);
        }
    ofPopMatrix();
    ofPushMatrix();
        ofTranslate(350, 420, 0);
        ofScale(1.484 , 0.4);
        
        // draw the input:
        ofSetColor(255, 255, 255,100);
        ofRect(0,0,256,200);
        ofSetColor(255, 255, 255);
        for (int i = 0; i < initialBufferSize/2; i++){
            ofLine(i,100,i,100+rAudioIn[i]*100.0f);
        }
    ofPopMatrix();
    
    
    //compass
    
    ofPushMatrix();	
        ofTranslate(175, 375, 0);
        ofScale(.2, .2);
        ofRotateZ(heading);
        imgCompass.draw(0,0);
    ofPopMatrix();
    
    
    //weather    
    ofSetColor(255, 255, 255,100);
    ofRect(350, 550, 380, 200);
    
    ofDisableAlphaBlending();
    

    if(hasGPS){
        cout << coreLocation->getLatitude()<<" | "<< coreLocation->getLongitude() << endl;
        
        lati  = ofMap(coreLocation->getLatitude() ,-90.00  ,90.00  ,0  ,0);
        longi = ofMap(coreLocation->getLongitude(),0.00    ,180.00 ,0  ,0);
        
        ofSetColor(255,255,255);
        ofDrawBitmapString("Lat:"+ofToString(coreLocation->getLatitude()),ofGetWidth()-120,ofGetHeight()-30);
        ofDrawBitmapString("Long:"+ofToString(coreLocation->getLongitude()),ofGetWidth()-120,ofGetHeight()-20);

    }
    
    
//    imgCompass.draw(160-120,380-120,240,240);
    
}

//--------------------------------------------------------------
void testApp::guiEvent(ofxUIEventArgs &e)
{
	string name = e.widget->getName(); 
	int kind = e.widget->getKind(); 
	
	if(name == "Beat in 1")
	{
		ofxUISlider *slider = (ofxUISlider *) e.widget; 
		beat1 = slider->getScaledValue(); 
        cout << "value: " << slider->getScaledValue() << endl; 
	}
	else if(name == "Beat in 2")
	{
		ofxUISlider *slider = (ofxUISlider *) e.widget; 
		beat2 = slider->getScaledValue(); 
        cout << "value: " << slider->getScaledValue() << endl; 
	}
//    else if(name == "RSLIDER")
//    {
//        ofxUIRangeSlider *rslider = (ofxUIRangeSlider *) e.widget; 
//        cout << "valuelow: " << rslider->getScaledValueLow() << endl; 
//        cout << "valuehigh: " << rslider->getScaledValueHigh() << endl;   
//    }
    else if(name == "NEW YORK")
    {
        ofxUI2DPad *pad = (ofxUI2DPad *) e.widget; 
        cout << "value x: " << pad->getScaledValue().x << endl; 
        cout << "value y: " << pad->getScaledValue().y << endl;         
    }
//    else if(name == "CSLIDER" || name == "CSLIDER 2")
//    {
//        ofxUIRotarySlider *rotslider = (ofxUIRotarySlider *) e.widget; 
//        cout << "value: " << rotslider->getScaledValue() << endl; 
//    }
    else if(name == "LAT.LONG")
    {
        ofxUI2DPad *pad = (ofxUI2DPad *) e.widget; 
        cout << "value x: " << pad->getScaledValue().x << endl; 
        cout << "value y: " << pad->getScaledValue().y << endl;         
    }
}    
//--------------------------------------------------------------
void testApp::exit(){
    
    delete gui1; 
    delete gui2; 
    delete gui3; 

}

//--------------------------------------------------------------
void testApp::audioOut(float * output, int bufferSize, int nChannels){
	
	if( initialBufferSize != bufferSize ){
		ofLog(OF_LOG_ERROR, "your buffer size was set to %i - but the stream needs a buffer size of %i", initialBufferSize, bufferSize);
		return;
	}	
	
	for (int i = 0; i < bufferSize; i++){
        
		wave = stretches[current]->play(speed*2, rate, 0.1, 4, 0);
        
        if (fft.process(wave)) {
			oct.calculate(fft.magnitudes);
		}
		
		sample = beatSamp.play(beatbar,0, beatSamp.length);
        synth1 = myOsc1.sinewave(goDirection);
        
		channel1.stereo(sample+wave,outputs1,0.2);
        channel2.stereo(synth1, outputs2, 0.7);
		
		lAudioOut[i] = output[i*nChannels    ] = outputs1[0] + outputs2[0];
		rAudioOut[i] = output[i*nChannels + 1] = outputs1[1] + outputs2[1];
		
	}
	
}

//--------------------------------------------------------------
void testApp::audioIn(float * input, int bufferSize, int nChannels){
    
    if( initialBufferSize != bufferSize ){
		ofLog(OF_LOG_ERROR, "your buffer size was set to %i - but the stream needs a buffer size of %i", initialBufferSize, bufferSize);
		return;
	}	
	
	// samples are "interleaved"
	for (int i = 0; i < bufferSize; i++){
		lAudioIn[i] = input[i*2];
		rAudioIn[i] = input[i*2+1];
	}
	bufferCounter++;
}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs &touch){

}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs &touch){
	speed       = ( (double)  touch.x / ofGetWidth()    * 4.0) - 2.0;
	grainLength = ( (double)  touch.y / ofGetHeight()   * 0.1) + 0.001;
	pos         = ( (double)  touch.x / ofGetWidth()    * 2.0);
    
    rate        = ( (double)  touch.y / ofGetHeight()   * 4.0) - 2.0;

}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs &touch){

}

//--------------------------------------------------------------
void testApp::touchDoubleTap(ofTouchEventArgs &touch){

}

//--------------------------------------------------------------
void testApp::lostFocus(){

}

//--------------------------------------------------------------
void testApp::gotFocus(){

}

//--------------------------------------------------------------
void testApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void testApp::deviceOrientationChanged(int newOrientation){

}

//--------------------------------------------------------------
void testApp::touchCancelled(ofTouchEventArgs& args){
	
}

//--------------------------------------------------------------

void testApp::drawGrid(float x, float y)
{
    float w = ofGetWidth(); 
    float h = ofGetHeight(); 
    
    for(int i = 0; i < h; i+=y){
        ofLine(0,i,w,i); 
    }
    
    for(int j = 0; j < w; j+=x){
        ofLine(j,0,j,h); 
    }    
}

