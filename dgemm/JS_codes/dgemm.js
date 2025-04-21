
/* setting the function to create matrixes */
function createM(size, empty=false){
    let m = [];
    var i = size;
    while (i>0) {
        var j = size;
        let row = [];
        while (j>0) {
            var n = 0
            if (!empty) {var n = Math.floor(Math.random()*size);}
            row.push(Number(n)); /* the range of the numbers that will be sorted and put inside the matrix is the size, so if the matrix is 800x800, the numbers inside will be integers between 0-799 */
            j--;
        }
        m.push(row);
        i--;
    }
    return m;
}

/* setting matrixes multipliction */
function mult_mat(s, m1, m2, mr, t, tc){

    /* starting time (st=startTime, stc=startTimeCPU*/
    const st = Date.now();
    const stc = performance.now();

    /* multiplying*/
    for (let i of Array(s).keys()) {
        for (let j of Array(s).keys()) {
            for (let k of Array(s).keys()) {
                mr[i][j] += Number(m1[i][k]) * Number(m2[k][j]);
            }
        }
    }

    /* ending time (st=startTime, stc=startTimeCPU*/
    const et = Date.now();
    const etc = performance.now();

    t = et - st;
    tc = etc - stc;

    return [t, tc];
}

/* Defining size of the matrix */
let size = 3;
size--;

/* creating the matrixes */
let mat1 = createM(size);
let mat2 = createM(size);
let matres = createM(size, true); /* matrix of result */

let time, timeCPU = [0, 0];
let time_list = mult_mat(size, mat1, mat2, matres, time, timeCPU);


console.log(mat1);
console.log(mat2);
console.log('');
console.log(matres);
console.log(time_list);

