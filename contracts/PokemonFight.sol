pragma solidity >=0.4.21 <0.7.0;
pragma experimental ABIEncoderV2;

contract PokemonFight {
    event BattleStatus(string _message);

    struct PokemonData {
        string PokemonName;
        uint256 PokemonHealth;
    }

    struct PokeBattle {
        PokemonData Pokemon1;
        PokemonData Pokemon2;
    }
    mapping(uint256 => PokeBattle[]) BattleDetails;
    uint256 public BattleNo = 0;
    function battleStart(
        string memory pokename1,
        uint256 pokehealth1,
        string memory pokename2,
        uint256 pokehealth2
    ) public {
        BattleDetails[BattleNo].push(
            PokeBattle(
                PokemonData(pokename1, pokehealth1),
                PokemonData(pokename2, pokehealth2)
            )
        );
        emit BattleStatus("Battle started");
    }

    function battleContinue(
        string memory pokename1,
        uint256 pokehealth1,
        string memory pokename2,
        uint256 pokehealth2
    ) public {
        if (pokehealth1 == 0 || pokehealth2 == 0) {
            BattleDetails[BattleNo].push(
                PokeBattle(
                    PokemonData(pokename1, pokehealth1),
                    PokemonData(pokename2, pokehealth2)
                )
            );
            BattleNo += 1;
            emit BattleStatus("Battle ended");
        } else {
            BattleDetails[BattleNo].push(
                PokeBattle(
                    PokemonData(pokename1, pokehealth1),
                    PokemonData(pokename2, pokehealth2)
                )
            );
        }
    }

}
