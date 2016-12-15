local OVALE, Ovale = ...
local OvaleScripts = Ovale.OvaleScripts

do
	local name = "ovale_monk_spells"
	local desc = "[7.0] Ovale: Monk spells"
	local code = [[
# Monk spells and functions.

Define(blackout_kick 100784)
	SpellInfo(blackout_kick cd=3)
	SpellInfo(blackout_kick chi=1 specialization=windwalker)
	SpellRequire(blackout_kick chi 0=buff,combo_breaker_bok_buff specialization=windwalker)
	SpellRequire(blackout_kick refund_chi cost=buff,serenity_buff if_spell=serenity specialization=windwalker)
	SpellAddBuff(blackout_kick combo_breaker_bok_buff=0)
	SpellAddBuff(blackout_kick cranes_zeal_buff=1)
	SpellAddBuff(blackout_kick shuffle_buff=1)
	SpellAddBuff(blackout_kick teachings_of_the_monastery_buff=0)
Define(blackout_strike 205523)
Define(black_ox_brew 115399)
	SpellInfo(black_ox_brew cd=90 gcd=0 offgcd=1 talent=black_ox_brew_talent)
Define(black_ox_brew_talent 8)
Define(bok_proc_buff 116768) #Alias for combo_breaker_bok_buff
Define(breath_of_fire 115181)
	SpellAddTargetBuff(breath_of_fire breath_of_fire_debuff=1 if_target_debuff=keg_smash_debuff)
Define(breath_of_fire_debuff 123725)
	SpellInfo(breath_of_fire_debuff duration=8 tick=2)
Define(brew_stache_buff 214373)
Define(brew_stache_trait 214372)
Define(crackling_jade_lightning 117952)
	SpellInfo(crackling_jade_lightning channel=4)
	SpellAddBuff(crackling_jade_lightning power_strikes_buff=0 talent=power_strikes_talent)
Define(cranes_zeal_buff 127722)
	SpellInfo(cranes_zeal_buff duration=20)
Define(chi_burst 123986)
	SpellInfo(chi_burst cd=30 travel_time=1)
Define(chi_burst_talent 6)
Define(chi_explosion_heal 157675)
	SpellInfo(chi_explosion_heal chi=finisher max_chi=4)
Define(chi_explosion_melee 152174)
	SpellInfo(chi_explosion_melee chi=finisher max_chi=4)
	SpellInfo(chi_explosion_melee buff_chi=combo_breaker_ce_buff buff_chi_amount=-2)
Define(chi_explosion_tank 157676)
	SpellInfo(chi_explosion_tank chi=finisher max_chi=4)
Define(chi_explosion_talent 20)
Define(chi_jis_guidance_buff 167717)
	SpellInfo(chi_jis_guidance_buff duration=60 max_stacks=2)
Define(chi_torpedo 115008)
Define(chi_torpedo_talent 18)
Define(chi_wave 115098)
	SpellInfo(chi_wave cd=15)
Define(chi_wave_talent 4)
Define(combo_breaker 137384)
Define(combo_breaker_bok_buff 116768)
	SpellInfo(combo_breaker_bok_buff duration=15)
Define(combo_breaker_ce_buff 159407)
	SpellInfo(combo_breaker_ce_buff duration=15)
Define(combo_breaker_tp_buff 118864)
	SpellInfo(combo_breaker_tp_buff duration=15)
Define(dampen_harm 122278)
	SpellInfo(dampen_harm cd=120 gcd=0 offgcd=1)
	SpellAddBuff(dampen_harm dampen_harm_buff=3)
Define(dampen_harm_buff 122278)
	SpellInfo(dampen_harm_buff duration=45)
Define(dampen_harm_talent 14)
Define(death_note_buff 121125)
Define(detonate_chi 115460)
	SpellInfo(detonate_chi cd=10)
Define(diffuse_magic 122783)
	SpellInfo(diffuse_magic cd=120 gcd=0 offgcd=1)
Define(diffuse_magic_buff 122783)
	SpellInfo(diffuse_magic_buff duration=6)
Define(diffuse_magic_talent 15)
Define(dizzying_haze_debuff 116330)
	SpellInfo(dizzying_haze_debuff duration=15)
Define(elusive_brew_stacks_buff 128939)
	SpellInfo(elusive_brew_stacks_buff duration=30 max_stacks=15)
Define(elusive_dance_buff 196739)
Define(elusive_dance_talent 19)
Define(energizing_brew 115288)
	SpellInfo(energizing_brew cd=60 gcd=0)
	SpellInfo(energizing_brew buff_cdr=cooldown_reduction_agility_buff)
	SpellAddBuff(energizing_brew energizing_brew_buff=1)
Define(energizing_brew_buff 115288)
	SpellInfo(energizing_brew_buff duration=6 tick=1)
	SpellInfo(energizing_brew_buff addduration=5 itemset=T14_melee itemcount=4)
Define(energizing_elixir 115288)
	SpellInfo(energizing_elixir chi=refill energy=refill)
Define(enveloping_mist 124682)
	SpellInfo(enveloping_mist chi=3)
	SpellAddTargetBuff(enveloping_mist enveloping_mist_buff=1)
Define(enveloping_mist_buff 132120)
	SpellInfo(enveloping_mist_buff duration=6 tick=1)
Define(expel_harm 115072)
	SpellInfo(expel_harm energy=15 specialization=brewmaster)
Define(exploding_keg 214326)
Define(extend_life_buff 185158)
	SpellInfo(extend_life_buff duration=12)
Define(fists_of_fury 113656)
	SpellInfo(fists_of_fury channel=4 cd=25)
	SpellInfo(fists_of_fury chi=3)
	SpellInfo(fists_of_fury chi=1 if_equipped=katsuos_eclipse_item)
	SpellRequire(fists_of_fury chi 0=buff,serenity_buff)
Define(focus_and_harmony 154555)
Define(focus_of_xuen_buff 145024)
	SpellInfo(focus_of_xuen_buff duration=10)
Define(fortifying_brew 115203)
	SpellInfo(fortifying_brew cd=420 gcd=0 offgcd=1)
	SpellInfo(fortifying_brew buff_cdr=cooldown_reduction_agility_buff specialization=windwalker)
	SpellInfo(fortifying_brew buff_cdr=cooldown_reduction_tank_buff specialization=brewmaster)
	SpellAddBuff(fortifying_brew fortifying_brew_buff=1)
Define(fortifying_brew_buff 120954)
	SpellInfo(fortifying_brew_buff duration=15)
Define(gale_burst 195399)
	SpellAddBuff(gale_burst gale_burst_buff=1)
Define(gale_burst_buff 195403)
Define(healing_elixir 122281)
	SpellInfo(healing_elixir charges=2 cd=30 talent=healing_elixir_talent)
Define(healing_elixir_talent 13)
Define(heavy_stagger_debuff 124273)
	SpellInfo(heavy_stagger_debuff duration=10 tick=1)
Define(hurricane_strike 152175)
	SpellInfo(hurricane_strike channel=2 cd=45 chi=3)
Define(hurricane_strike_talent 19)
Define(improved_breath_of_fire 157362)
Define(improved_renewing_mist 157398)
Define(invoke_xuen 123904)
	SpellInfo(invoke_xuen cd=180 talent=invoke_xuen_talent)
Define(invoke_xuen_talent 17)
Define(ironskin_brew 115308)
	SpellInfo(ironskin_brew cd=21 charges=3 gcd=0 offgcd=1 cd_haste=melee)
	SpellInfo(ironskin_brew cd=18 charges=4 gcd=0 offgcd=1 cd_haste=melee talent=light_brewing_talent)
Define(ironskin_brew_buff 215479)
Define(jab 100780)
	SpellInfo(jab chi=-1)
	SpellInfo(jab buff_chi=power_strikes_buff talent=power_strikes_talent)
	SpellAddBuff(jab power_strikes_buff=0 talent=power_strikes_talent)
Define(katsuos_eclipse_item 137029)
Define(keg_smash 121253)
	SpellInfo(keg_smash cd=8 energy=40 specialization=brewmaster)
	SpellAddDebuff(keg_smash keg_smash_debuff=1)
Define(keg_smash_debuff 121253)
Define(legacy_of_the_emperor 115921)
	SpellAddBuff(legacy_of_the_emperor legacy_of_the_emperor_buff=1)
Define(legacy_of_the_emperor_buff 115921)
	SpellInfo(legacy_of_the_emperor_buff duration=10)
Define(legacy_of_the_white_tiger 116781)
	SpellAddBuff(legacy_of_the_white_tiger legacy_of_the_white_tiger_buff=1)
Define(legacy_of_the_white_tiger_buff 116781)
	SpellInfo(legacy_of_the_white_tiger_buff duration=10)
Define(leg_sweep 119381)
	SpellAddDebuff(leg_sweep leg_sweep_debuff duration=5)
Define(leg_sweep_debuff 119381)
Define(light_brewing_talent 7)
Define(light_stagger_debuff 124275)
	SpellInfo(light_stagger_debuff duration=10 tick=1)
Define(mana_tea 115294)
	SpellInfo(mana_tea channel=6 texture=inv_misc_herb_jadetealeaf)
Define(mana_tea_buff 115867)
	SpellInfo(mana_tea_buff duration=120 max_stacks=20)
Define(moderate_stagger_debuff 124274)
	SpellInfo(moderate_stagger_debuff duration=10 tick=1)
Define(nimble_brew 137562)
	SpellInfo(nimble_brew cd=120 gcd=0 offgcd=1)
Define(paralysis 115078)
	SpellInfo(paralysis cd=15 interrupt=1)
Define(power_strikes_buff 129914)
Define(power_strikes_talent 7)
Define(purifying_brew 119582)
	SpellInfo(purifying_brew cd=21 charges=3 gcd=0 offgcd=1 cd_haste=melee)
	SpellInfo(purifying_brew cd=18 charges=4 gcd=0 offgcd=1 cd_haste=melee talent=light_brewing_talent)
Define(refreshing_jade_wind 196725)
	SpellInfo(refreshing_jade_wind cd=6 mana=5)
Define(refreshing_jade_wind_talent 16)
Define(renewing_mist 115151)
	SpellInfo(renewing_mist cd=8 chi=-1)
	SpellAddBuff(renewing_mist thunder_focus_tea_buff=0 if_spell=thunder_focus_tea)
	SpellAddTargetBuff(renewing_mist renewing_mist_buff=1)
	SpellAddTargetBuff(renewing_mist extend_life_buff=1 itemset=T18 itemcount=2)
Define(renewing_mist_buff 119611)
	SpellInfo(renewing_mist_buff duration=18 haste=spell tick=2)
	SpellInfo(renewing_mist_buff addduration=2 if_spell=improved_renewing_mist)
Define(revival 115310)
	SpellInfo(revival cd=180)
Define(rising_sun_kick 107428)
	SpellInfo(rising_sun_kick cd=8 chi=2)
	SpellRequire(rising_sun_kick refund_chi cost=buff,serenity_buff if_spell=serenity)
Define(rushing_jade_wind 116847)
	SpellInfo(rushing_jade_wind cd=6 cd_haste=melee talent=rushing_jade_wind_talent)
	SpellInfo(rushing_jade_wind cd=6 cd_haste=melee talent=rushing_jade_wind_talent chi=1 specialization=windwalker)
Define(rushing_jade_wind_talent 16)
Define(serenity 152173)
	SpellInfo(serenity cd=90 gcd=0)
	SpellAddBuff(serenity serenity_buff=1)
Define(serenity_buff 152173)
	SpellInfo(serenity_buff duration=10)
	SpellInfo(serenity_buff duration=5 specialization=brewmaster)
Define(serenity_talent 21)
Define(shuffle_buff 115307)
	SpellInfo(shuffle_buff duration=6)
Define(soothing_mist 115175)
	SpellInfo(soothing_mist cd=1 channel=8)
	SpellInfo(soothing_mist soothing_mist_buff=1)
Define(soothing_mist_buff 115175)
	SpellInfo(soothing_mist_buff duration=8 haste=spell tick=1)
Define(spear_hand_strike 116705)
	SpellInfo(spear_hand_strike cd=15 gcd=0 interrupt=1 offgcd=1)
Define(spinning_crane_kick 101546)
	SpellInfo(spinning_crane_kick duration=1.5 tick=0.5)
	SpellInfo(spinning_crane_kick chi=3 specialization=windwalker)
Define(storm_earth_and_fire 137639)
	SpellInfo(storm_earth_and_fire tag=shortcd)
	SpellAddBuff(storm_earth_and_fire storm_earth_and_fire_buff=1)
Define(storm_earth_and_fire_buff 137639)
	SpellInfo(storm_earth_and_fire_buff max_stacks=2)
Define(strike_of_the_windlord 205320)
	SpellInfo(strike_of_the_windlord cd=40 chi=2 tag=main)
Define(summon_black_ox_statue 115315)
	SpellInfo(summon_black_ox_statue cd=10 duration=900 totem=1)
Define(summon_jade_serpent_statue 115313)
	SpellInfo(summon_jade_serpent_statue cd=10 duration=900 totem=1)
Define(surging_mist 116694)
	SpellInfo(surging_mist chi=-1 specialization=mistweaver)
	SpellRequire(surging_mist chi -2=buff,vital_mists_buff,5 itemset=T17 itemset=2 specialization=mistweaver)
	SpellAddBuff(surging_mist thunder_focus_tea_buff=0 if_spell=thunder_focus_tea)
Define(t18_class_trinket 124517)
Define(teachings_of_the_monastery_buff 202090)
	SpellInfo(teachings_of_the_monastery_buff duration=12 max_stacks=3)
Define(thunder_focus_tea 116680)
	SpellInfo(thunder_focus_tea cd=45 gcd=0)
	SpellInfo(thunder_focus_tea addcd=-5 itemset=T15_heal itemcount=4)
	SpellRequire(thunder_focus_tea chi 1=buff,chi_jis_guidance_buff itemset=T17 itemcount=4 specialization=mistweaver)
	SpellAddBuff(thunder_focus_tea chi_jis_guidance_buff=-1 itemset=T17 itemcount=4 specialization=mistweaver)
	SpellAddBuff(thunder_focus_tea thunder_focus_tea_buff=1)
Define(thunder_focus_tea_buff 116680)
	SpellInfo(thunder_focus_tea_buff duration=30)
Define(tiger_palm 100780)
	SpellInfo(tiger_palm energy=50 specialization=windwalker)
	SpellInfo(tiger_palm energy=25 specialization=brewmaster)
	SpellAddBuff(tiger_palm teachings_of_the_monastery_buff=1)
Define(tigereye_brew 116740)
	SpellInfo(tigereye_brew cd=5 gcd=0)
	SpellAddBuff(tigereye_brew tigereye_brew_buff=-10 tigereye_brew_use_buff=1)
Define(tigereye_brew_buff 125195)
	SpellInfo(tigereye_brew_buff duration=120 max_stacks=20)
Define(tigereye_brew_use_buff 116740)
	SpellInfo(tigereye_brew_use_buff duration=15)
Define(touch_of_death 115080)
	SpellInfo(touch_of_death cd=120)
Define(touch_of_death_debuff 115080)
Define(uplift 116670)
	SpellInfo(uplift chi=2)
Define(vital_mists_buff 118674)
	SpellInfo(vital_mists_buff duration=30)
Define(whirling_dragon_punch 152175)
	SpellInfo(whirling_dragon_punch cd=24 unusable=1)
	SpellRequire(whirling_dragon_punch unusable 0=oncooldown,rising_sun_kick)
	SpellRequire(whirling_dragon_punch unusable 0=oncooldown,fists_of_fury)
Define(zen_meditation 115176)
	SpellInfo(zen_meditation cd=300 gcd=0 offgcd=1)
	SpellInfo(zen_meditation buff_cdr=cooldown_reduction_agility_buff specialization=windwalker)
	SpellInfo(zen_meditation buff_cdr=cooldown_reduction_tank_buff specialization=brewmaster)
Define(zen_sphere 124081)
	SpellInfo(zen_sphere cd=10)
	SpellAddTargetBuff(zen_sphere zen_sphere_buff=1)
Define(zen_sphere_buff 124081)
	SpellInfo(zen_sphere_buff duration=16 haste=spell tick=2)
Define(zen_sphere_talent 5)

# Non-default tags for OvaleSimulationCraft.
	SpellInfo(chi_brew tag=main)
	SpellInfo(chi_torpedo tag=shortcd)
	SpellInfo(dampen_harm tag=cd)
	SpellInfo(diffuse_magic tag=cd)
]]

	OvaleScripts:RegisterScript("MONK", nil, name, desc, code, "include")
end