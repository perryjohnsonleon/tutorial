	const element1 = document.getElementById("myBar1");
	const stockId_list=['2330','1102','1101','2356','1504','2371','2324','8150','2317','2002','2027','1402','1301','2887','2353','2347','3706','5410','2449','2308']
	let stockId=0 ;
	window.addEventListener('load',function(){
		startShow();
		element1.style.width = '0%';  
		document.getElementById("s01").addEventListener("change", refreshTime); 			
	}); 
	
   function refreshTime() {
             switch ( $(this).val()) {
					  case "A": 
							window.location.href = 'https://perryjohnsonleon.github.io/tutorial/index_a.htm' ;
							break;
					  case "B":
							window.location.href = 'https://perryjohnsonleon.github.io/tutorial/index_b.htm'	;
							break;
					  case "C": 
							window.location.href = 'https://perryjohnsonleon.github.io/tutorial/index_c.htm' ;
							break;
					  case "D": 
							window.location.href = 'https://perryjohnsonleon.github.io/tutorial/index_d.htm' ;
							break;
					  case "E": 
							window.location.href = 'https://perryjohnsonleon.github.io/tutorial/index_e.htm' ;
							break;
					  case "F": 
							window.location.href = 'https://perryjohnsonleon.github.io/tutorial/index_f.htm' ;
							break;
					  case "W": 
							window.location.href = 'https://perryjohnsonleon.github.io/exercise2/index_w.htm' ;
							break;
					  case "X": 
							window.location.href = 'https://perryjohnsonleon.github.io/exercise2/index_x.htm' ;
							break;
					  case "Z": 
							window.location.href = 'https://perryjohnsonleon.github.io/tutorial/index_z.htm' ;
							break;
					  case "P": 
							window.location.href = 'https://perryjohnsonleon.github.io/tutorial/graph.htm' ;
							break;
					  case "-1": 
							window.location.href = 'https://perryjohnsonleon.github.io/exercise' ;
							break;
                  case "0": 
                     width = 100;
                     refSec = 99999 ;
                     element1.style.width = '0%'; 
                     break;
                  case "1": 
                     refSec = 3000 ;
                     break;
                  case "2":
                     refSec = 5000 ;
                     break;
                  case "3": 
                     refSec = 10000 ;
                     break;
                  case "5": 
                     refSec = 30000 ;
                     break;
                  case "6": 
                  refSec = 60000 ;
                     break;
                  case "7": 
                     refSec = 600000 ;
                     break; 
                  case "10": 
                     refSec = 1800000 ;
                     break;                                     
                  default:
                     refSec = 60000 ;
                     return;
                    } 
				   while(intervalIds.length){
                          clearInterval(intervalIds.pop());
					}
				   if  (refSec != 99999 ) {
				       id = setInterval(getDATA,refSec);
				       intervalIds.push(id); 
					 }
					 else 
					 {
						  while(intervalIds.length){
							  clearInterval(intervalIds.pop());
							}						
					 }
		}	
 
  async function getpricePost(stockId) {
	  try {
	   let itemPrice_matrix="" ;
	   let oldCanvas = document.getElementById("hiddenMsg2");
	  // let oldCollapseBtn = document.getElementById("collapseBtn2");
	   if (oldCanvas && stockId == -1) {
	      oldCanvas.outerHTML = "<div id='hiddenMsg2' style='display:none;'><canvas id='myChart' width='750' height='400'  display='none'></canvas><div id='collapseBtn2' style='display:none;justify-content:center;'><img src='collapse.png' style='cursor:pointer;' onclick='getPost(0)' /></div></div>" ;
	      return 0;
		}
		else {
		  oldCanvas.outerHTML = "<div id='hiddenMsg2'><canvas id='myChart' width='750' height='400'></canvas><div id='collapseBtn2' style='justify-content:center;'><img src='collapse.png' style='cursor:pointer;' onclick='getpricePost(-1)' /></div></div>" ;
		}
		let fetchUrl_str1="https://ws.api.cnyes.com/ws/api/v1/charting/history?resolution=1&symbol=TWS:" , fetchUrl_str2=":STOCK&quote=1"   ;
		let fetchUrl_str=fetchUrl_str1 + stockId_list[stockId] + fetchUrl_str2 ;
		const response = await fetch(fetchUrl_str);
		if (!response.ok) {
		  throw new Error(`HTTP error! status: ${response.status}`);
		}

		const post = await response.json(); // Convert response to JS object
		return post;
	  } catch (error) {
		console.error('Fetch error:', error);
		return null;
	  }
	}
 
 async function getPost(stockId) {
	  try {
		let fetchUrl_str="" ;
		let fetchUrl_str1="https://ws.api.cnyes.com/ws/api/v1/charting/history?resolution=1&symbol=TWS:" , fetchUrl_str2=":STOCK&quote=1"   ;
		if (stockId == 9999 ) 
			fetchUrl_str="https://ws.api.cnyes.com/ws/api/v1/charting/history?symbol=TWS:TSE01:INDEX&resolution=D&quote=1&from=NaN&to=NaN"
		else
			fetchUrl_str=fetchUrl_str1 + stockId_list[stockId] + fetchUrl_str2 ;
		const response = await fetch(fetchUrl_str);
		if (!response.ok) {
		  throw new Error(`HTTP error! status: ${response.status}`);
		}
		const post = await response.json(); // Convert response to JS object
		return post;
	  } catch (error) {
		console.error('Fetch error:', error);
		return null;
     }
  }


 async function displayPost(stockId) {
	  const post = await getPost(stockId);
	  if (stockId == 9999) {
			if (post) {
				const quote_obj = post.data.quote ;	
				for ( var n in quote_obj) {
					if ( n == "11" ) {
						if (quote_obj[n]> 0) 
                            {
							document.getElementById("wi-d").classList.add("wi-risePrice");
                            } 
                        else {
                          if (quote_obj[n] === 0){ 
                           	document.getElementById("wi-d").classList.add("wi-flatPrice");                           	  	 		
                          }
                          else {
							document.getElementById("wi-d").classList.add("wi-fellPrice");
                          }
                        }
						document.getElementById("wi-d").innerHTML = quote_obj[n] + '(D)' ;		
					} 		
				}
				document.getElementById("wi-c").innerHTML= post.data.c + '(現)';
				document.getElementById("wi-h").innerHTML= post.data.h + '(H)';
				document.getElementById("wi-l").innerHTML= post.data.l + '(L)';						
			}	
	  }
	  else {
			const num = stockId+1 ;
			let elemId_1="item-1" + num , elemId_2="item-2" + num , elemId_3="item-3" + num , elemId_4="item-4" + num , elemId_5="item-5" + num ;
			if (post) {
				const quote_obj = post.data.quote ;
				for ( var n in quote_obj) {
				if ( n == "200009" ) document.getElementById(elemId_1).innerHTML =  "<span class='span_rpt'>" + quote_obj[n] + "</span>" ;
				if ( n == "6" ) document.getElementById(elemId_2).innerHTML =  "<button class='btn2-expand' onclick='realtimePrice(" + stockId + ",false);'>" + quote_obj[n] + "</button>" ;
				if ( n == "11" ) {
						if ( quote_obj[n]> 0) {
								document.getElementById(elemId_2).classList.add('risePrice');
								document.getElementById(elemId_3).classList.add('risePrice');
							} 
						else {
							if ( quote_obj[n] === 0){ 
								document.getElementById(elemId_2).classList.add('flatPrice');
								document.getElementById(elemId_3).classList.add('flatPrice');
								}
							else {
								document.getElementById(elemId_2).classList.add('fellPrice');
								document.getElementById(elemId_3).classList.add('fellPrice');	
								}
						}
					document.getElementById(elemId_3).innerHTML =  "<span class='span_rpt'>" + quote_obj[n] + "</span>" ;
				
				}	   
				if ( n == "12" ) document.getElementById(elemId_4).innerHTML =  "<span class='span_rpt'>" + quote_obj[n] + "</span>" ;
				if ( n == "13" ) document.getElementById(elemId_5).innerHTML =  "<span class='span_rpt'>" + quote_obj[n] + "</span>" ;
				}
			}
	  }
  } 

 async function realtimePrice(stockId) {
   const post = await getpricePost(stockId);
   if ( post !=0 ) {
	  let itemPrice_name = "" , itemPrice_weight= 0 , itemPrice_height = 0 ;
	  let xValues_str="0";
	  if (post) {
		const itemPrice_arry = post.data.c;
		const quote_obj = post.data.quote ;
		for ( var n in quote_obj) {
		   if ( n == "200009" ) itemPrice_name= quote_obj[n] ;
		   if ( n == "6" ) itemPrice_weight= quote_obj[n] ;
		   if ( n == "11" ) itemPrice_height= quote_obj[n] ;
		}
		itemPrice_matrix =[...itemPrice_arry].reverse() ;	
		const xValues_matrix= Array.from({ length: itemPrice_matrix.length }, (_, index) => index + 1);
		const xValues = xValues_matrix;
		let original = itemPrice_matrix ;
		let yValues = original.map(n => n );
		let points = yValues.map((y, i) => ({ x: xValues[i], y }));
		let itemPrice_title = itemPrice_name + "(" + itemPrice_weight + ")" + "[" + itemPrice_height + "]" ; 
		let itemPrice_mid= itemPrice_weight - itemPrice_height ;
		var graph=new Chart(document.getElementById('myChart'), {
		  type: 'line',
		  data: {
			datasets: [{
			  label: itemPrice_title ,
			  data: points,
			  borderColor:'#1171FF',
			  borderWidth:1,
			  pointRadius:1,
			  cubicInterpolationMode: 'monotone',
			  tension: 0.4,
			  backgroundColor: 'rgba(17,113,255,0.6)',
			}]
		  },
		  options: { 
		  // *****
			responsive: true,
			plugins: {
			  legend: {
				display: true,
				labels: { font: { size: 14 } }
			  },
			  annotation: {
				annotations: {
				  midline: {
					type: 'line',
					yMin: itemPrice_mid,   // 中線 y 值
					yMax: itemPrice_mid,
					borderColor: 'red',
					borderWidth: 1,
					borderDash: [4, 4],
					label: {
					  display: true,
					  content: '',
					  color: 'red',
					  position: 'end',
					  backgroundColor: 'white'
					}
				  }
				}
			  }
			}		  
		  
		  // *****
		,scales: {
			  x: {
				type: 'linear', // 指定為數值型 x 軸
				title: { display: true, text: '時間' },
			  },
			  y: {
				beginAtZero: false,
				title: { display: true, text: '股價' },
			  }
			}
		  }
		});
	   }  
    }
  }   

  async function startShow() {
		await displayPost(9999);
		await displayPost(0);
		await displayPost(1);
		await displayPost(2);
		await displayPost(3);
		await displayPost(4);
		await displayPost(5);
		await displayPost(6);
		await displayPost(7);
		await displayPost(8);
		await displayPost(9);
		await displayPost(10);
		await displayPost(11);
		await displayPost(12);
		await displayPost(13);
		await displayPost(14);
		await displayPost(15);
		await displayPost(16);
		await displayPost(17);
		await displayPost(18);
		await displayPost(19);
	}  