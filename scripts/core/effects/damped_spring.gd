# Copyright (c) 2008-2012 Ryan Juckett
#  http://www.ryanjuckett.com/
 
#  This software is provided 'as-is', without any express or implied
#  warranty. In no event will the authors be held liable for any damages
#  arising from the use of this software.
 
#  Permission is granted to anyone to use this software for any purpose,
#  including commercial applications, and to alter it and redistribute it
#  freely, subject to the following restrictions:
 
#  1. The origin of this software must not be misrepresented; you must not
#     claim that you wrote the original software. If you use this software
#     in a product, an acknowledgment in the product documentation would be
#     appreciated but is not required.
 
#  2. Altered source versions must be plainly marked as such, and must not be
#     misrepresented as being the original software.
 
#  3. This notice may not be removed or altered from any source
#     distribution.

#  EDITED FROM ORIGINAL SOURCE FOR GDSCRIPT/GODOT USAGE

extends Node
class_name DampedSpring

@export var frequency: float
@export var damping_ratio: float
var target_value: float = 1.
var spring_params: SpringMotionParams = SpringMotionParams.new()
var target_params: SpringTargetParams = SpringTargetParams.new()

class SpringMotionParams:
    var pos_pos_coef: float
    var pos_vel_coef: float
    var vel_pos_coef: float
    var vel_vel_coef: float

class SpringTargetParams:
    var current_pos: float
    var velocity: float
    
func _process(delta: float) -> void:
    calculate_damped_spring(delta, frequency, damping_ratio)
    update_damped_spring_motion(target_value)

func calculate_damped_spring(delta: float, angular_freq: float, damping: float):
    const epsilon = 0.0001
    # force values into legal range
    if damping < 0.: damping = 0.
    if angular_freq < 0.: angular_freq = 0.

    # if there is no angular frequency, the spring will not move and we can
    # return identity
    if angular_freq < epsilon:
        spring_params.pos_pos_coef = 1.
        spring_params.pos_vel_coef = 0.
        spring_params.vel_pos_coef = 0.
        spring_params.vel_vel_coef = 1.
        return

    if damping > (1. + epsilon):
        # over-damped
        var za = -angular_freq * damping
        var zb = angular_freq * sqrt(damping*damping - 1.)
        var z1 = za - zb;
        var z2 = za + zb;

        var e1 = exp(z1 * delta)
        var e2 = exp(z2 * delta)

        var invTwoZb = 1. / (2.*zb)
            
        var e1_Over_TwoZb = e1*invTwoZb
        var e2_Over_TwoZb = e2*invTwoZb

        var z1e1_Over_TwoZb = z1*e1_Over_TwoZb
        var z2e2_Over_TwoZb = z2*e2_Over_TwoZb

        spring_params.pos_pos_coef =  e1_Over_TwoZb*z2 - z2e2_Over_TwoZb + e2
        spring_params.pos_vel_coef = -e1_Over_TwoZb    + e2_Over_TwoZb

        spring_params.vel_pos_coef = (z1e1_Over_TwoZb - z2e2_Over_TwoZb + e2)*z2
        spring_params.vel_vel_coef = -z1e1_Over_TwoZb + z2e2_Over_TwoZb
    elif damping < (1. - epsilon):    
        # under-damped
        var omegaZeta = angular_freq * damping
        var alpha     = angular_freq * sqrt(1. - damping*damping)
        var expTerm = exp( -omegaZeta * delta )
        var cosTerm = cos( alpha * delta )
        var sinTerm = sin( alpha * delta )
            
        var invAlpha = 1. / alpha;

        var expSin = expTerm*sinTerm
        var expCos = expTerm*cosTerm
        var expOmegaZetaSin_Over_Alpha = expTerm*omegaZeta*sinTerm*invAlpha

        spring_params.pos_pos_coef = expCos + expOmegaZetaSin_Over_Alpha
        spring_params.pos_vel_coef = expSin*invAlpha

        spring_params.vel_pos_coef = -expSin*alpha - omegaZeta*expOmegaZetaSin_Over_Alpha
        spring_params.vel_vel_coef =  expCos - expOmegaZetaSin_Over_Alpha
    else:
        #critically damped
        var expTerm     = exp( -angular_freq*delta );
        var timeExp     = delta*expTerm;
        var timeExpFreq = timeExp*angular_freq;

        spring_params.pos_pos_coef = timeExpFreq + expTerm;
        spring_params.pos_vel_coef = timeExp;

        spring_params.vel_pos_coef = -angular_freq*timeExpFreq;
        spring_params.vel_vel_coef = -timeExpFreq + expTerm;
    
func update_damped_spring_motion(target_pos: float):
    var oldPos = target_params.current_pos - target_pos
    var oldVel = target_params.velocity
    target_params.current_pos = oldPos * spring_params.pos_pos_coef + oldVel * spring_params.pos_vel_coef + target_pos
    target_params.velocity = oldPos * spring_params.vel_pos_coef + oldVel * spring_params.vel_vel_coef
