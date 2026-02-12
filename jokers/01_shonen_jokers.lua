local luffy = {
  key = 'luffy',
  pos = {x = 0, y = 0},
  config = {extra = {retriggers = 2}},
  loc_vars = function(self, info_queue, center)
	return {vars = {center.ability.extra.retriggers}}
  end,
  rarity = "shon_shonen",
  cost = 10,
  atlas = "ShonenJokers",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.repetition and not context.end_of_round and context.cardarea == G.play then
        if context.other_card:get_id() == 5 or context.other_card:get_id() == 6 then
            return {
                repetitions = card.ability.extra.retriggers,
                card = card
            }
        end
    end
  end,
}

local sakamoto = {
    key = "sakamoto",
    blueprint_compat = true,
    rarity = "shon_shonen",
    cost = 5,
    atlas = "ShonenJokers",
    pos = { x = 1, y = 0 },
    loc_vars = function(self, info_queue, card)
        if card.area and card.area == G.jokers then
            local other_joker
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card and G.jokers.cards[i + 1] then
                    if G.jokers.cards[i + 1].config.center.rarity == 1 or G.jokers.cards[i + 1].config.center.rarity == "Common" then
                        other_joker = G.jokers.cards[i + 1] 
                    end
                end
            end
            local compatible = other_joker and other_joker ~= card and other_joker.config.center.blueprint_compat
            main_end = {
                {
                    n = G.UIT.C,
                    config = { align = "bm", minh = 0.4 },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { ref_table = card, align = "m", colour = compatible and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8), r = 0.05, padding = 0.06 },
                            nodes = {
                                { n = G.UIT.T, config = { text = ' ' .. localize('k_' .. (compatible and 'compatible' or 'incompatible')) .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 } },
                            }
                        }
                    }
                }
            }
            return { main_end = main_end }
        end
    end,
    calculate = function(self, card, context)
        local other_joker = nil
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i] == card and G.jokers.cards[i + 1] then
                if G.jokers.cards[i + 1].config.center.rarity == 1 or G.jokers.cards[i + 1].config.center.rarity == "Common" then
                    other_joker = G.jokers.cards[i + 1] 
                end
            end
        end
        local ret = SMODS.blueprint_effect(card, other_joker, context)
        if ret then
            ret.colour = G.C.BLUE
        end
        return ret
    end,
}

local roboco = {
  key = 'roboco',
  pos = {x = 2, y = 0},
  config = {extra = {mult = 4, chips = 50, money = 2}},
  loc_vars = function(self, info_queue, center)
	return {vars = {center.ability.extra.mult, center.ability.extra.chips, center.ability.extra.money}}
  end,
  rarity = "shon_shonen",
  cost = 7,
  atlas = "ShonenJokers",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.other_joker and context.other_joker.config.center.rarity == "shon_shonen" then
      G.E_MANAGER:add_event(Event({
        func = function()
            context.other_joker:juice_up(0.5, 0.5)
            return true
        end
      })) 
      return {
        mult_mod = card.ability.extra.mult,
        chip_mod = card.ability.extra.chips,
        dollars = card.ability.extra.money
      }
    end
  end,
}

local gakuro = {
  key = 'gakuro',
  pos = {x = 7, y = 1},
  config = {extra = {limit = 1, ranks_played = {}, triggered = false}},
  loc_vars = function(self, info_queue, center)
    local info = center.ability.extra
    local card_vars = {info.limit}
    for i = 2, 14 do
        local rank_exists = info.ranks_played[''..shonen_joke.get_rank(i)]
        card_vars[#card_vars+1] = rank_exists and localize(''..shonen_joke.get_rank(i), 'ranks')..' ' or ''
    end
	return {vars = card_vars}
  end,
  rarity = "shon_shonen",
  cost = 10,
  atlas = "ShonenJokers",
  blueprint_compat = false,
  calculate = function(self, card, context)
    if context.joker_main and not context.blueprint then
        local ranks_played = card.ability.extra.ranks_played
        local rank_count = 0
        for i = 1, #context.full_hand do
            local played = context.full_hand[i]
            if not (SMODS.has_no_rank(played) or ranks_played[''..shonen_joke.get_rank(played:get_id())])  then
                ranks_played[''..shonen_joke.get_rank(played:get_id())] = true
            end
        end

        for k, v in pairs(ranks_played) do
            rank_count = rank_count + 1
        end

        if rank_count == 13 and not card.ability.extra.triggered then
            card.ability.extra.triggered = true
            if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                return {
                extra = {focus = card, message = localize('k_plus_spectral'), colour = G.C.PURPLE, func = function()
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = function()
                        SMODS.add_card{set = 'Spectral'}
                        G.GAME.consumeable_buffer = 0
                        return true
                    end
                }))
                end}
                }
            end
        end
    end
    if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
        card.ability.extra.ranks_played = {}
        card.ability.extra.triggered = false
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    SMODS.change_play_limit(card.ability.extra.limit)
    SMODS.change_discard_limit(card.ability.extra.limit)
  end,
  remove_from_deck = function(self, card, from_debuff)
    SMODS.change_play_limit(-card.ability.extra.limit)
    SMODS.change_discard_limit(-card.ability.extra.limit)
    if not G.GAME.before_play_buffer then
        G.hand:unhighlight_all()
    end
  end, 
}

local gonron = {
  key = 'gonron',
  pos = {x = 3, y = 1},
  config = {extra = {Xmult = 1, Xmult_mod = 0.25}},
  loc_vars = function(self, info_queue, center)
	return {vars = {center.ability.extra.Xmult, center.ability.extra.Xmult_mod}}
  end,
  rarity = "shon_shonen",
  cost = 9,
  atlas = "ShonenJokers",
  blueprint_compat = true,
  perishable_compat = false,
  calculate = function(self, card, context)
    if context.before and #context.scoring_hand == 1 and context.scoring_hand[1]:is_suit('Hearts') and not context.blueprint then
        card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod

        return {
          message = localize('k_upgrade_ex'),
          colour = G.C.XMULT
        }
    end

    if context.joker_main then
        return {
            message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult}}, 
            colour = G.C.XMULT,
            Xmult_mod = card.ability.extra.Xmult
        }
    end

    if context.destroying_card and #context.scoring_hand == 1 and context.scoring_hand[1]:is_suit('Hearts') then
        return true
    end
  end,
}

local yodaka = {
  key = 'yodaka',
  pos = {x = 4, y = 0},
  config = {extra = {mult = 4, Xmult = 1, Xmult_mod = 0.75, count = 3}},
  loc_vars = function(self, info_queue, center)
	return {vars = {center.ability.extra.mult, center.ability.extra.Xmult, center.ability.extra.Xmult_mod, center.ability.extra.count}}
  end,
  rarity = "shon_shonen",
  cost = 7,
  atlas = "ShonenJokers",
  blueprint_compat = true,
  calculate = function(self, card, context)
    
    if context.joker_main then
        local vars = {
            message = localize('k_shon_ninja'),
            colour = G.C.MULT,
            mult_mod = card.ability.extra.mult
        }
        if card.ability.extra.Xmult > 1 then
            vars.Xmult_mod = card.ability.extra.Xmult
        end
        return vars
    end

    if context.setting_blind and G.GAME.blind.boss and #G.jokers.cards <= card.ability.extra.count and not context.blueprint then
        card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod

        return {
          message = localize('k_upgrade_ex'),
          colour = G.C.XMULT
        }
    end
  end,
}

local kiyoshi = {
  key = 'kiyoshi',
  pos = {x = 8, y = 0},
  config = {extra = {Xmult_multi = 2.5}},
  loc_vars = function(self, info_queue, center)
	return {vars = {center.ability.extra.Xmult_multi}}
  end,
  rarity = "shon_shonen",
  cost = 10,
  atlas = "ShonenJokers",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and not context.end_of_round and context.cardarea == G.play and #context.scoring_hand == 3 then
        local all_sevens = true
        for i = 1, #context.scoring_hand do
            if context.scoring_hand[i]:get_id() ~= 7 then
                all_sevens = nil
            end
        end
        if all_sevens then
            return {
                x_mult = card.ability.extra.Xmult_multi,
                card = card
            }
        end
    end
  end,
}

local ichi = {
  key = 'ichi',
  pos = {x = 5, y = 0},
  config = {extra = {booster_slot = 1}},
  loc_vars = function(self, info_queue, center)
	return {vars = {center.ability.extra.booster_slot}}
  end,
  rarity = "shon_shonen",
  cost = 4,
  atlas = "ShonenJokers",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.playing_card_added and not card.getting_sliced and context.cards then
      if context.cards and type(context.cards) == "table" and #context.cards > 0 then
        local cards_added = {}
        for k, v in ipairs(context.cards) do
          if type(v) == "table" then
            if v:get_id() == 4 and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                SMODS.add_card {
                                    set = 'Tarot',
                                    key = 'c_death'
                                }
                                G.GAME.consumeable_buffer = 0
                                return true
                            end
                        }))
                        SMODS.calculate_effect({ message = localize('k_plus_tarot'), colour = G.C.PURPLE },
                            context.blueprint_card or card)
                        return true
                    end)
                }))
            end
          end
        end
      end
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    SMODS.change_booster_limit(card.ability.extra.booster_slot)
  end,
  remove_from_deck = function(self, card, from_debuff)
    SMODS.change_booster_limit(-card.ability.extra.booster_slot)
  end,
}

local tokiyuki = {
  key = 'tokiyuki',
  pos = {x = 3, y = 0},
  config = {extra = {}},
  loc_vars = function(self, info_queue, center)
    info_queue[#info_queue + 1] = { key = 'tag_double', set = 'Tag' }
	return {vars = {}}
  end,
  rarity = "shon_shonen",
  cost = 7,
  atlas = "ShonenJokers",
  blueprint_compat = false,
  eternal_compat = false,
  calculate = function(self, card, context)
    if context.selling_self and not context.blueprint then
        for i = 1, #G.GAME.tags do
            G.E_MANAGER:add_event(Event({
                func = (function()
                    add_tag(Tag('tag_double'))
                    play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                    play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                    return true
                end)
            }))
        end
    end
  end,
}

local chinatsu_taiki = {
  key = 'chinatsu_taiki',
  pos = {x = 7, y = 0},
  config = {extra = {chips = 0, chip_mod = 4}},
  loc_vars = function(self, info_queue, center)
	return {vars = {center.ability.extra.chips, center.ability.extra.chip_mod}}
  end,
  rarity = "shon_shonen",
  cost = 4,
  atlas = "ShonenJokers",
  blueprint_compat = false,
  calculate = function(self, card, context)
    if context.before and context.cardarea == G.jokers and next(context.poker_hands['Pair']) and not context.blueprint then
        local commons = 0
        for k, v in ipairs(G.jokers.cards) do
            if v.config.center.rarity == 1 or v.config.center.rarity == "Common" then
                commons = commons + 1
            end
        end
        if commons > 0 then
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod * commons
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.CHIPS,
                card = card
            }
        end
    end
    if context.joker_main and card.ability.extra.chips > 0 then
        return {
            message = localize{type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips}}, 
            colour = G.C.CHIPS,
            chip_mod = card.ability.extra.chips
        }
    end
  end,
}

local maru = {
  key = 'maru',
  pos = {x = 5, y = 1},
  config = {extra = {rerolls = 5, shop_limit = 1}},
  loc_vars = function(self, info_queue, center)
	return {vars = {center.ability.extra.rerolls, center.ability.extra.shop_limit}}
  end,
  rarity = "shon_shonen",
  cost = 8,
  atlas = "ShonenJokers",
  blueprint_compat = false,
  eternal_compat = false,
  calculate = function(self, card, context)
    if context.reroll_shop and not context.blueprint then
        local destructable_jokers = {}
        local adjacent_jokers = shonen_joke.get_adjacent_jokers(card)
        for i = 1, #G.jokers.cards do
            local adjacent = nil
            for k, v in pairs(adjacent_jokers) do
                if G.jokers.cards[i] == v then 
                    adjacent = true 
                    break    
                end
            end
            if not adjacent and G.jokers.cards[i] ~= card and not SMODS.is_eternal(G.jokers.cards[i], card) and not G.jokers.cards[i].getting_sliced then
                destructable_jokers[#destructable_jokers + 1] =
                    G.jokers.cards[i]
            end
        end
        local joker_to_destroy = pseudorandom_element(destructable_jokers, 'maru')

        if joker_to_destroy then
            joker_to_destroy.getting_sliced = true
            G.E_MANAGER:add_event(Event({
                func = function()
                    (context.blueprint_card or card):juice_up(0.8, 0.8)
                    joker_to_destroy:start_dissolve({ G.C.RED }, nil, 1.6)
                    return true
                end
            }))
        end
    end
  end,
add_to_deck = function(self, card, from_debuff)
    SMODS.change_free_rerolls(card.ability.extra.rerolls)
    change_shop_size(card.ability.extra.shop_limit)
  end,
  remove_from_deck = function(self, card, from_debuff)
    SMODS.change_free_rerolls(-card.ability.extra.rerolls)
    change_shop_size(-card.ability.extra.shop_limit)
  end,
}

local nico = {
  key = 'nico',
  pos = {x = 0, y = 1},
  config = {extra = {tags = 1}},
  loc_vars = function(self, info_queue, center)
    info_queue[#info_queue + 1] = { key = 'tag_charm', set = 'Tag' }
	return {vars = {center.ability.extra.tags}}
  end,
  rarity = "shon_shonen",
  cost = 7,
  atlas = "ShonenJokers",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.setting_blind then
        G.E_MANAGER:add_event(Event({
            func = function()
                for i = 1, card.ability.extra.tags do
                    add_tag(Tag('tag_charm'))
                end
                play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                ease_discard(-G.GAME.current_round.discards_left, nil, true)
                card:juice_up()
                return true
            end
        }))
    end
  end,
}

local asuka_demonlord = {
  key = 'asuka_demonlord',
  pos = {x = 4, y = 1},
  config = {extra = {money = 20}},
  loc_vars = function(self, info_queue, center)
    info_queue[#info_queue+1] = G.P_CENTERS.c_devil
    info_queue[#info_queue+1] = G.P_CENTERS.c_justice
	return {vars = {center.ability.extra.money}}
  end,
  rarity = "shon_shonen",
  cost = 6,
  atlas = "ShonenJokers",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.selling_card then
        if context.card and context.card.config and (context.card.config.center_key == "c_devil" or context.card.config.center_key == "c_justice") then
            ease_dollars(card.ability.extra.money)
            card:juice_up()
        end
    end
  end,
}

local akane = {
  key = 'akane',
  pos = {x = 1, y = 1},
  config = {extra = {}},
  loc_vars = function(self, info_queue, center)
      if not center.edition or (center.edition and not center.edition.polychrome) then
        info_queue[#info_queue+1] = G.P_CENTERS.e_polychrome
      end
      if not center.edition or (center.edition and not center.edition.foil) then
        info_queue[#info_queue+1] = G.P_CENTERS.e_foil
      end
      if not center.edition or (center.edition and not center.edition.holo) then
        info_queue[#info_queue+1] = G.P_CENTERS.e_holo
      end
	return {vars = {}}
  end,
  rarity = "shon_shonen",
  cost = 10,
  atlas = "ShonenJokers",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.before and G.GAME.current_round.hands_left == 0 and #context.full_hand == 1 then
        local editions = {{foil = true}, {holo = true}, {polychrome = true}}
        local cards_copied = {}
        for i = 1, #editions do
            G.playing_card = (G.playing_card and G.playing_card + 1) or 1
            local card_copied = copy_card(context.full_hand[1], nil, nil, G.playing_card)
            card_copied:add_to_deck()
            G.deck.config.card_limit = G.deck.config.card_limit + 1
            table.insert(G.playing_cards, card_copied)
            G.hand:emplace(card_copied)
            card_copied.states.visible = nil
            cards_copied[#cards_copied+1] = card_copied

            G.E_MANAGER:add_event(Event({
                func = function()
                    local edition = editions[i]
                    card_copied:set_edition(edition, true)
                    card_copied:start_materialize()
                    return true
                end
            }))
        end
        return {
            message = localize('k_copied_ex'),
            colour = G.C.CHIPS,
            func = function() -- This is for timing purposes, it runs after the message
                G.E_MANAGER:add_event(Event({
                    func = function()
                        SMODS.calculate_context({ playing_card_added = true, cards = cards_copied })
                        return true
                    end
                }))
            end
        }
    end
  end,
}

local mimei_kurage = {
  key = 'mimei_kurage',
  pos = {x = 2, y = 1},
  config = {extra = {retriggers = 1, ranks_discarded = {},}},
  loc_vars = function(self, info_queue, center)
    local info = center.ability.extra
    local card_vars = {info.retriggers}
    for i = 2, 14 do
        local rank_exists = info.ranks_discarded[''..shonen_joke.get_rank(i)]
        card_vars[#card_vars+1] = rank_exists and localize(''..shonen_joke.get_rank(i), 'ranks')..' ' or ''
    end
	return {vars = card_vars}
  end,
  rarity = "shon_shonen",
  cost = 6,
  atlas = "ShonenJokers",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.pre_discard and G.GAME.current_round.discards_used == 0 then
        local ranks_discarded = card.ability.extra.ranks_discarded
        for i = 1, #G.hand.highlighted do
            local discarded = G.hand.highlighted[i]
            if not (SMODS.has_no_rank(discarded) or ranks_discarded[''..shonen_joke.get_rank(discarded:get_id())])  then
                ranks_discarded[''..shonen_joke.get_rank(discarded:get_id())] = true
            end
        end
    end
    if context.repetition and context.cardarea == G.play then
        local ranks_discarded = card.ability.extra.ranks_discarded
        if ranks_discarded[''..shonen_joke.get_rank(context.other_card:get_id())] then
            return {
                repetitions = card.ability.extra.retriggers
            }
        end
    end

    if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
        card.ability.extra.ranks_discarded = {}
    end
  end,
}

local osoegawa = {
  key = 'osoegawa',
  pos = {x = 6, y = 1},
  config = {extra = {consumeable_limit = 1}},
  loc_vars = function(self, info_queue, center)
	return {vars = {center.ability.extra.consumeable_limit}}
  end,
  rarity = "shon_shonen",
  cost = 10,
  atlas = "ShonenJokers",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.ending_shop and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
        local card_to_copy = nil
        for i = 1, #G.consumeables.cards do
            if G.consumeables.cards[i].config.center.set == 'Tarot' then
                card_to_copy, _ = G.consumeables.cards[i]
                break
            end
        end
        if card_to_copy then
            G.E_MANAGER:add_event(Event({
                func = function()
                    local copied_card = copy_card(card_to_copy)
                    copied_card:add_to_deck()
                    G.consumeables:emplace(copied_card)
                    G.GAME.consumeable_buffer = 0
                    return true
                end
            }))
            return { message = localize('k_duplicated_ex') }
        end
    end
  end,
add_to_deck = function(self, card, from_debuff)
    G.consumeables.config.card_limit = G.consumeables.config.card_limit + card.ability.extra.consumeable_limit
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.consumeables.config.card_limit = G.consumeables.config.card_limit - card.ability.extra.consumeable_limit
  end, 
}

local chihiro = {
  key = 'chihiro',
  pos = {x = 6, y = 0},
  config = {extra = {Xmult_multi = 1.2, retriggers = 1}},
  loc_vars = function(self, info_queue, center)
	return {vars = {center.ability.extra.Xmult_multi}}
  end,
  rarity = "shon_shonen",
  cost = 10,
  atlas = "ShonenJokers",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and not context.end_of_round and context.cardarea == G.play and context.other_card:is_suit('Spades') then
        return {
            x_mult = card.ability.extra.Xmult_multi,
            card = card
        }
    end
    if context.individual and context.cardarea == G.hand and not context.end_of_round and context.other_card:is_suit('Hearts') then
        if context.other_card.debuff then
            return {
                message = localize('k_debuffed'),
                colour = G.C.RED
            }
        else
            return {
                x_mult = card.ability.extra.Xmult_multi
            }
        end
    end
    if context.repetition and context.cardarea == G.hand and (next(context.card_effects[1]) or #context.card_effects > 1) and SMODS.has_enhancement(context.other_card, 'm_gold') then
      return {
        message = localize('k_again_ex'),
        repetitions = card.ability.extra.retriggers,
        card = card
      }
    end
    if context.repetition and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, 'm_gold') then
        return {
            repetitions = card.ability.extra.retriggers
        }
    end
  end,
}

local tenichi = {
  key = 'tenichi',
  pos = {x = 9, y = 0},
  config = {extra = {money = 3, money_mod = 3, money_original = 3}},
  loc_vars = function(self, info_queue, center)
	return {vars = {center.ability.extra.money, center.ability.extra.money_mod}}
  end,
  rarity = "shon_shonen",
  cost = 10,
  atlas = "ShonenJokers",
  blueprint_compat = false,
  calculate = function(self, card, context)
    if context.before and context.cardarea == G.jokers and next(context.poker_hands['Full House']) and not context.blueprint then
        card.ability.extra.money = card.ability.extra.money + card.ability.extra.money_mod

        return {
            message = localize('k_upgrade_ex'),
            colour = G.C.MONEY,
            card = card
        }
    end
    if context.setting_blind and G.GAME.blind.name == "Small Blind" then
        card.ability.extra.money = card.ability.extra.money_original
        return {
            message = localize('k_reset'),
            colour = G.C.RED
        }
    end
  end,
  calc_dollar_bonus = function(self, card)
    return card.ability.extra.money
  end
}

local kinato = {
  key = 'kinato',
  pos = {x = 9, y = 1},
  config = {extra = {spectral_used = false}},
  loc_vars = function(self, info_queue, center)
    local active = center.ability.extra.spectral_used and localize('k_shon_active') or localize('k_shon_inactive')
	return {vars = {active}}
  end,
  rarity = "shon_shonen",
  cost = 8,
  atlas = "ShonenJokers",
  blueprint_compat = false,
  calculate = function(self, card, context)
    if context.using_consumeable and not context.blueprint and context.consumeable.ability.set == 'Spectral' then
        card.ability.extra.spectral_used = true
        local eval = function(card) return card.ability.extra.spectral_used and not G.RESET_JIGGLES end
        juice_card_until(card, eval, true)
    end
    if context.final_scoring_step and card.ability.extra.spectral_used then
        card.ability.extra.spectral_used = false
        return {
            balance = true
        }
    end
  end,
}

local haiji = {
  key = 'haiji',
  pos = {x = 8, y = 1},
  config = {extra = {minus_money = 3}},
  loc_vars = function(self, info_queue, center)
	return {vars = {center.ability.extra.minus_money}}
  end,
  rarity = "shon_shonen",
  cost = 6,
  atlas = "ShonenJokers",
  blueprint_compat = false,
  calculate = function(self, card, context)
    if context.first_hand_drawn then
        local eval = function() return G.GAME.current_round.discards_used == 0 and not G.RESET_JIGGLES end
        juice_card_until(card, eval, true)
    end
    if context.discard and not context.blueprint and G.GAME.current_round.discards_used <= 0 and (#context.full_hand == 2 or #context.full_hand == 1)  then
        local no_faces = true
        for i = 1, #context.full_hand do
            if context.full_hand[i]:is_face() then
                no_faces = nil
                break
            end
        end
        if no_faces then
            return {
                dollars = -card.ability.extra.minus_money,
                remove = true,
                delay = 0.45
            }
        end
    end
  end,
}

local ouga = {
  key = 'ouga',
  pos = {x = 0, y = 2},
  config = {extra = {Xmult = 1, Xmult_mod = 0.4}},
  loc_vars = function(self, info_queue, center)
    info_queue[#info_queue+1] = G.P_CENTERS.m_shon_alien
	return {vars = {center.ability.extra.Xmult, center.ability.extra.Xmult_mod}}
  end,
  rarity = "shon_shonen",
  cost = 6,
  atlas = "ShonenJokers",
  blueprint_compat = false,
  calculate = function(self, card, context)
    if context.discard and #context.full_hand == 2 and not context.blueprint then
        local face = nil
        local alien = nil
        for i = 1, #context.full_hand do
            if context.full_hand[i]:is_face() and not SMODS.has_enhancement(context.full_hand[i], 'm_shon_alien') then
                face = context.full_hand[i]
            elseif SMODS.has_enhancement(context.full_hand[i], 'm_shon_alien') then
                alien = context.full_hand[i]
            end
        end
        if face and alien and context.other_card == alien then
            SMODS.scale_card(card, {
            ref_value = 'Xmult',
            scalar_value = 'Xmult_mod',
            })

            return {
                remove = true,
                delay = 0.45
            }
        end
    end

    if context.joker_main then
        return {
            xmult = card.ability.extra.Xmult
        }
    end
  end,
}

local full_joker_list = {luffy, sakamoto, roboco, gakuro, gonron, yodaka, kiyoshi, ichi, tokiyuki, chinatsu_taiki, maru, nico, asuka_demonlord, akane, mimei_kurage,
            osoegawa, chihiro, tenichi, kinato, haiji, ouga}

local current_joker_list = {}

for i = 1, #full_joker_list do
    if shonen_joke.config.allow_finished or not full_joker_list[i].finished then
        if shonen_joke.config.shon_rare_rarity then 
            full_joker_list[i].rarity = 3
        end
        full_joker_list[i].unlocked = true
        current_joker_list[#current_joker_list+1] = full_joker_list[i]
    end
end

items = {
    list = current_joker_list
}

return items