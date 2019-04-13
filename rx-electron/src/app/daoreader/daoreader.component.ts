import { Component } from '@angular/core';
import { Resource } from '../models/resource';
import {Web3Service} from '../util/web3.service';

const resource_artifacts = require('../../../../build/contracts/XS.json');

@Component({
  selector: 'daoreader',
  templateUrl: './daoreader.component.html',
  styleUrls: ['./daoreader.component.scss']
})
export class DaoReaderComponent {
  resources: Resource[] = [];
  selectedresource: Resource
  contractAbstraction: any
  contractInstance: any
  
  constructor(private web3Service: Web3Service){
    console.log('Constructor: ' + web3Service);
  }

  ngOnInit(){
    this.resources.push({id:"123",version:1,name:"Team4Resources"})
    this.selectedresource = this.resources[0];
    //this.monitorDAO();
    this.web3Service.artifactsToContract(resource_artifacts)
      .then((resAbstraction) => {
        this.contractAbstraction = resAbstraction;
        this.contractAbstraction.deployed().then(deployed => {
          this.contractInstance = deployed
          //console.log(deployed);
          //deployed.Transfer({}, (err, ev) => {
            //console.log('Transfer event came in, refreshing graph');
            this.refreshGraph();
          //});
        });

      });
  }

  public getResource(){

  }

  async refreshGraph(){
      console.log('Refreshing graph');
      try {
        //const deployedResource = await this.resdata.deployed();
        console.log(this.contractInstance);
        var data = await this.contractInstance.listResources()
        //console.log('Resource updates', this.selectedresource);

        //const resourceData = await this.contractInstance.ResourceDAO.call(this.selectedresource);
       // let xs = await this.contractInstance("0x411462843112065019997341e316b64a6d46e513")
       // var data = xs.listResourcesName()
        console.log('Found info: ' + data);
        //this.resources.push(resourceData);
      } catch (e) {
        console.log(e);
        //this.setStatus('Error getting resource; see log.');
      }
  }

  compareObjects(o1: any, o2: any): boolean {
    return o1.name === o2.name && o1.id === o2.id;
  }

  monitorDAO() {
    this.web3Service.resourceObservable.subscribe((resources) => {
      //this.resources = resources;
      //this.model.resource = resources[0];
      //this.refreshBalance();
    });
  }
}
