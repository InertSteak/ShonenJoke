return {
    descriptions = {
        Back={},
        Blind={},
        Edition={},
        Enhanced={},
        Joker={
            j_shon_luffy = {
                name = 'Luffy',
                text = {
                    "Retrigger all played",
                    "{C:attention}5s{} and {C:attention}6s #1#{} times"
                }
            },
            j_shon_sakamoto = {
                name = 'Sakamoto',
                text = {
                    "Copy the {C:chips}Common",
                    "Joker to the right",
                }
            },
            j_shon_roboco = {
                name = 'Roboco',
                text = {
                    "Each {C:shonen}Shonen{} Joker gives",
                    "{C:mult}+#1#{} Mult, {C:chips}+#2#{} Chips and {C:money}$#3#",
                }
            },
            j_shon_gakuro = {
                name = 'Gakuro',
                text = {
                    "{C:attention}+#1#{} card selection limit",
                    "Create a {C:spectral}Spectral{} card after",
                    "playing every {C:attention}rank{} this round",
                    "{C:inactive}(Currently played: #2##3##4##5##6##7##8##9##10##11##12##13##14#){}"
                }
            },
            j_shon_gonron = {
                name = 'Gonron',
                text = {
                    "If played hand is exactly",
                    "{C:attention}1{} {C:hearts}Heart{} gain {X:mult,C:white} X#2# {} Mult and",
                    "destroy it after scoring",
                    "{C:inactive}(Currently {X:mult,C:white} X#1# {C:inactive} Mult){}",
                }
            },
            j_shon_yodaka = {
                name = 'Yodaka',
                text = {
                    "{C:mult}+#1#{} Mult",
                    "When {C:attention}Boss Blind{} is selected,",
                    "gains {X:mult,C:white} X#3# {} Mult if you",
                    "have {C:attention}#4#{} or less Jokers",
                    "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult){}",
                }
            },
            j_shon_kiyoshi = {
                name = 'Kiyoshi',
                text = {
                    "If played hand is exactly",
                    "{C:attention}3 7s{}, each give {X:mult,C:white} X#1# {} Mult{}"
                }
            },
            j_shon_ichi = {
                name = 'Ichi',
                text = {
                    "{C:attention}+1{} Booster Pack slot",
                    "When you add a {C:attention}4{} to deck,",
                    "create a {C:tarot}Death{} card",
                    "{C:inactive,s:0.8}(Must have room)",
                }
            },
            j_shon_tokiyuki = {
                name = 'Tokiyuki',
                text = {
                    "Sell this card to",
                    "create a {C:attention}Double Tag{} for",
                    "each {C:attention}Tag{} you have"
                }
            },
            j_shon_chinatsu_taiki = {
                name = "Chinatsu & Taiki",
                text = {
                    "Gains {C:chips}+#2#{} Chips for each {C:chips}Common{}",
                    "Joker you have if played",
                    "hand contains a {C:attention}Pair{}",
                    "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)",
                } 
            }, 
            j_shon_maru = {
                name = 'Maru',
                text = {
                    "{C:attention}+#1#{} free {C:green}Rerolls{} per shop",
                    "{C:attention}+#2#{} card slot available in shop",
                    "Rerolling {C:attention}destroys{} a random Joker",
                    "that isn't adjacent to this Joker"
                }
            },
            j_shon_nico = {
                name = 'Nico',
                text = {
                    "When {C:attention}Blind{} is selected,",
                    "Create a {C:tarot}Charm{} {C:attention}Tag",
                    "and {C:attention}lose all discards",
                }
            },
            j_shon_asuka_demonlord = {
                name = 'Asuka & Demon Lord',
                text = {
                    "When you sell a {C:tarot}Justice",
                    "or {C:tarot}Devil{} card earn {C:money}$#1#{}",
                }
            },
            j_shon_akane = {
                name = 'Akane',
                text = {
                    "If played hand has only {C:attention}1{} card",
                    "and you have {C:attention}no hands remaining",
                    "add a {C:dark_edition}Foil{}, a {C:dark_edition}Holographic{}, and a",
                    "{C:dark_edition}Polychrome{} copy to deck",
                    "and draw them to {C:attention}hand"
                }
            },
            j_shon_mimei_kurage = {
                name = 'Mimei & Kurage',
                text = {
                    "Retrigger all cards played that",
                    "share a {C:attention}rank{} with a card",
                    "in {C:attention}first{} discarded hand",
                    "{C:inactive}(Retriggers: #2##3##4##5##6##7##8##9##10##11##12##13##14#){}"
                }
            },
            j_shon_osoegawa = {
                name = 'Osoegawa',
                text = {
                    "{C:attention}+#1#{} consumable slots",
                    "Create a copy of the {C:attention}first{}",
                    "{C:tarot}Tarot{} card in your possession",
                    "at end of {C:attention}shop",
                    "{C:inactive,s:0.8}(Must have room)",
                }
            },
            j_shon_chihiro = {
                name = 'Chihiro',
                text = {
                    "Each played {C:spades}Spade{} gives {X:mult,C:white} X#1# {} Mult{}",
                    "when scored, each {C:hearts}Heart{} {C:attention}held{} in hand",
                    "gives {X:mult,C:white} X#1# {} Mult{}, and all played or",
                    "held {C:attention}Gold{} cards retrigger",
                }
            },
            j_shon_tenichi = {
                name = 'Tenichi',
                text = {
                    "Earn {C:money}$#1#{} at end of round. If",
                    "played hand contains a {C:attention}Full House",
                    "increase payout by {C:money}$#2#{}, resets",
                    "when Small Blind is selected",
                }
            },
            j_shon_kinato = {
                name = 'Kinato',
                text = {
                    "After using a {C:spectral}Spectral{} card, balances",
                    "{C:chips}Chips{} and {C:mult}Mult{} when calculating",
                    "score for {C:attention}next{} played hand",
                    "{C:inactive}(#1#){}"
                }
            },
            j_shon_haiji = {
                name = 'Haiji',
                text = {
                    "If {C:attention}first{} discard is {C:attention}1 or 2 non-Face{}",
                    "cards destroy them and lose",
                    "{C:money}$#1#{} for each destroyed",
                }
            },
        },
        Other={
            p_shon_jumppack_normal_1 = {
                name = "Jump Pack",
                text = {
                    "Choose {C:attention}#1#{} {C:shonen}Shonen{} Joker",
                    "from among {C:attention}#2#{} Cards"
                },
            },
        },
        Planet={},
        Spectral={},
        Stake={},
        Tag={
            tag_shon_shonen_tag = {
                name = "Shonen Tag",
                text = {
                    "Gives a free {C:shonen}Jump Pack",
                }, 
            },
        },
        Tarot={},
        Voucher={},
    },
    misc = {
        achievement_descriptions={},
        achievement_names={},
        blind_states={},
        challenge_names={},
        collabs={},
        dictionary={
            k_shon_shonen = "Shonen",
            k_shon_ninja = "Ninja!",
            k_shon_active = "Active!",
            k_shon_inactive = "Inactive",

            shon_finished = "Allow Finished Series?"
        },
        high_scores={},
        labels={
            k_shon_shonen = "Shonen",
        },
        poker_hand_descriptions={},
        poker_hands={},
        quips={},
        ranks={},
        suits_plural={},
        suits_singular={},
        tutorial={},
        v_dictionary={},
        v_text={},
    },
}