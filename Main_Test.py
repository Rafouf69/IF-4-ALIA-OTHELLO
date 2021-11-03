
import json
from multiprocessing import Process


def run_prolog():
    print('eee')
    from pyswip import Prolog, registerForeign
    prolog = Prolog()
    prolog.consult("test.pl")
    res = prolog.query("run")
    # Generating result in output.txt
    for result in res:
        break


if __name__ == '__main__':
    # Opening JSON parameter file
    f = open('parameters.json', )
    parameter = json.load(f)

    ITERATION = parameter["iterations"]
    LEVEL1 = parameter["level_1"]
    LEVEL2 = parameter["level_2"]
    GRID_DIM = parameter["grid_dimension"]

    # Closing file
    f.close()

    # GENERATE PL FILE
    with open("Othello.pl.template", "r") as myfile:
        data = myfile.read()

    data = data.replace("$$$BOARD_DIMENSION$$$",
                        str(GRID_DIM + 48));  # En prolog 1 correspond à 49, 4 à 52 (faire un write C dans get C)
    data = data.replace("$$$LEVEL_MODE$$$", str(LEVEL1 + 48));
    data = data.replace("$$$LEVEL_MODE_2$$$", str(LEVEL2 + 48));

    file = open('test.pl', 'w')
    file.write("")
    file.write(data)
    file.close()

    # https://groups.google.com/g/swi-prolog/c/3xctENNrHD8

    for i in range(ITERATION):
        process = Process(target=run_prolog, args=[])
        process.start()
        process.join()
        print(process.is_alive())
        # from here output has been written into output.txt
        # open file output to get result
        f = open("output.txt", "r")
        text = ""
        for x in f:
            result1 = x.split("-")[0]
            result2 = x.split("-")[1]
        print(result1)
        print(result2)


        try:
            f = open('results.json', )
            result = json.load(f)
            f.close()
        except IOError as e:
            print(e)
            print("First occurence")
            result = {}
        if i == 0:
            result["result"] = []
            result["result"].append({"player1:":result1,"player2:":result2})
            result["iterations"] = ITERATION
            result["grid_dimension"] = GRID_DIM
            result["level_1"] = LEVEL1
            result["level_2"] = LEVEL2
        else:
            result["result"].append({"player1:": result1, "player2:": result2})

        with open('results.json', 'w') as outfile:
            json.dump(result, outfile, sort_keys=True, indent=4)
