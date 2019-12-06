<?php

namespace medicine\models\search;

use common\models\queries\ActiveQuery;
use medicine\models\CompanyPerson;
use yii\base\Model;
use yii\data\ActiveDataProvider;

/**
 * CompanyPersonSearch represents the model behind the search form about `common\models\CompanyPerson`.
 */
class CompanyPersonSearch extends CompanyPerson
{
    /** @var ActiveQuery */
    public $query;
    public $perPage = 20;

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            [['id', 'companyId', 'personId'], 'safe'],
        ];
    }

    /**
     * @inheritdoc
     */
    public function scenarios()
    {
        // bypass scenarios() implementation in the parent class
        return Model::scenarios();
    }

    /**
     * Creates data provider instance with search query applied
     *
     * @param array $params
     *
     * @return ActiveDataProvider
     */
    public function search($params)
    {
        $query = $this->query;
        if (!$query) {
            $query = static::find();
        }

        // add conditions that should always apply here

        $dataProvider = new ActiveDataProvider([
            'query' => $query,
            'pagination' => [
                'pageSize' => $this->perPage,
            ],
        ]);

        $this->load($params);

        if (!$this->validate()) {
            // uncomment the following line if you do not want to return any records when validation fails
            // $query->where('0=1');
            return $dataProvider;
        }

        // фильтруем по id
        $query->andFilterWhere([
            'id' => $this->id,
        ]);

        // фильтруем по компании
        if(is_int($this->companyId)){ // в companyId номер модели компании
            $query->andWhere(['companyId' => $this->companyId]);
        } elseif($this->companyId) { // в companyId часть названия компании
            $query->joinWith(['company' => function ($q) {
                $q->where('company.name LIKE "%' . $this->companyId . '%"');
            }]);
        }

        // filter by person name
        if(is_int($this->personId)){ // в personId номер модели персоны
            $query->andWhere(['personId' => $this->personId]);
        } elseif($this->personId) { // в personId часть имени
            $query->joinWith(['person' => function ($q) {
                $q->where('person.name LIKE "%' . $this->personId . '%"');
            }]);
        }
        
        return $dataProvider;
    }
}

