#include maps\_anim;
main()
{
    // Autogenerated by AnimSounds. Threaded off so that it can be placed before _load( has to create level.scr_notetrack first ).
    thread init_animsounds();
}

init_animsounds()
{
    waittillframeend;
    addNotetrack_animSound( "ending_alasad", "coup_ending", "fire_gun", "assassination_shot" ); 
    addNotetrack_animSound( "ending_alasad", "coup_ending", "cock_gun", "assassination_hammer" ); 
    addNotetrack_animSound( "playerview", "coup_opening", "hit", "melee_hit" );
}
