
import { useState } from 'react';
import {ethers} from 'ethers';
import './App.css';
import Counter from './artifacts/contracts/Opensource.sol/Opensource.json';

const counterAddress = '0x5FbDB2315678afecb367f032d93F642f64180aa3';

const provider = new ethers.providers.Web3Provider(window.ethereum); // with metamask
const signer = provider.getSigner();
const contract = new ethers.Contract(counterAddress,Counter.abi,signer);
function App() {

  const [fund,createfund] = useState(0);
  const [request,createRequest] = useState(0);
  
 const applyfund = async () =>{
  const result = await contract.createRequest();
  result.wait();
  console.log(request);
 }
  return (
    
    <div className="App">
      <header className="App-header">
       <h1 className='h1'>Opensource </h1>
      </header>
      <body>
       <button type='button' className='btn' onClick={applyfund} >Create</button>
       
      </body>
      <footer className='footer'>
      <h3 className='fh3'>Made by Jay </h3>
      </footer>
    </div>
  );
}

export default App;
